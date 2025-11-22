<?php

namespace APP\plugins\generic\multipressIndex;

use APP\core\Application;
use APP\facades\Repo;
use APP\press\NewReleaseDAO;
use APP\press\PressDAO;
use PKP\db\DAORegistry;
use PKP\plugins\GenericPlugin;
use PKP\plugins\Hook;

class MultipressIndexPlugin extends GenericPlugin
{
    public function register($category, $path, $mainContextId = null)
    {
        $success = parent::register($category, $path, $mainContextId);
        
        if (!$success) {
            return false;
        }
        
        // Load plugin locale files
        $this->addLocaleData();

        if (Application::isUnderMaintenance()) {
            return true;
        }
        
        if ($this->getEnabled($mainContextId)) {
            // Register hooks
            Hook::add('TemplateManager::display', [$this, 'handleTemplateDisplay']);
            Hook::add('LoadHandler', [$this, 'handleLoadHandler']);
        }
        
        return true;
    }

    public function getDisplayName()
    {
        return __('plugins.generic.multipressIndex.displayName');
    }

    public function getDescription()
    {
        return __('plugins.generic.multipressIndex.description');
    }

    /**
     * @copydoc Plugin::getCanEnable()
     */
    public function getCanEnable($contextId = null)
    {
        return true;
    }

    /**
     * @copydoc Plugin::getCanDisable()
     */
    public function getCanDisable($contextId = null)
    {
        return true;
    }

    public function handleLoadHandler($hookName, $params)
    {
        $page = $params[0];
        $op = $params[1];
        
        // Check if this is the site index
        if ($page === 'index' && $op === 'index') {
            $request = Application::get()->getRequest();
            $press = $request->getPress();
            
            error_log('MultipressIndex: At site index, press=' . ($press ? $press->getId() : 'NULL'));
        }
        
        return false;
    }

    public function handleTemplateDisplay($hookName, $params)
    {
        $templateMgr = $params[0];
        $template = $params[1];
        
        $request = Application::get()->getRequest();
        $router = $request->getRouter();
        $requestedPage = $router->getRequestedPage($request);

        // Skip admin pages
        if (in_array($requestedPage, ['admin', 'manager', 'user', 'login'])) {
            return false;
        }

        $press = $request->getPress();
        
        // Only process site index (no press context)
        if ($press !== null) {
            return false;
        }
        
        // Check if this is an index page
        if (strpos($template, 'index') === false && strpos($template, 'Site') === false) {
            return false;
        }
        
        // Get all presses and their new releases
        $pressDao = DAORegistry::getDAO('PressDAO');
        $newReleaseDao = DAORegistry::getDAO('NewReleaseDAO');
        $allPresses = $pressDao->getAll(true)->toArray();
        $allNewReleases = [];

        foreach ($allPresses as $press) {
            if ($press && $press->getId()) {
                $pressNewReleases = $newReleaseDao->getMonographsByAssoc(
                    Application::ASSOC_TYPE_PRESS,
                    $press->getId()
                );
                
                if (!empty($pressNewReleases) && is_array($pressNewReleases)) {
                    foreach ($pressNewReleases as $monograph) {
                        if ($monograph) {
                            $monograph->setData('pressPath', $press->getPath());
                            $monograph->setData('pressName', $press->getLocalizedName());
                            $allNewReleases[] = $monograph;
                        }
                    }
                }
            }
        }

        // Sort by publication date
        if (!empty($allNewReleases)) {
            usort($allNewReleases, function ($a, $b) {
                $pubA = $a->getCurrentPublication();
                $pubB = $b->getCurrentPublication();

                if (!$pubA || !$pubB) {
                    return 0;
                }

                $dateA = $pubA->getData('datePublished');
                $dateB = $pubB->getData('datePublished');

                if (!$dateA || !$dateB) {
                    return 0;
                }

                return strcmp($dateB, $dateA);
            });

            $allNewReleases = array_slice($allNewReleases, 0, 30);
        }

        // Get author user groups
        $authorUserGroups = new \Illuminate\Support\Collection();
        if (!empty($allPresses)) {
            $firstPress = reset($allPresses);
            if ($firstPress && $firstPress->getId()) {
                $authorUserGroups = Repo::userGroup()
                    ->getCollector()
                    ->filterByRoleIds([\PKP\security\Role::ROLE_ID_AUTHOR])
                    ->filterByContextIds([$firstPress->getId()])
                    ->getMany()
                    ->remember();
            }
        }

        // Assign template variables
        $templateMgr->assign([
            'newReleases' => $allNewReleases,
            'authorUserGroups' => $authorUserGroups,
            'monographListTemplate' => $this->getTemplateResource('frontend/components/monographListMultipress.tpl'),
            'monographSummaryTemplate' => $this->getTemplateResource('frontend/objects/monograph_summary_multipress.tpl')
        ]);

        // Change template
        $params[1] = $this->getTemplateResource('frontend/pages/indexSite.tpl');

        return false;
    }
}

if (!PKP_STRICT_MODE) {
    class_alias('\APP\plugins\generic\multipressIndex\MultipressIndexPlugin', '\MultipressIndexPlugin');
}