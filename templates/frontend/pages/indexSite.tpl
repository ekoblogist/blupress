{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Site index - displaying new releases from all presses
 *
 *}
{include file="frontend/components/header.tpl"}

<div class="page page_homepage">
	
	{* About/Description section *}
	{if $about}
		<div class="additional_content">
			{$about}
		</div>
	{/if}
	
	{* New releases from all presses *}
	{if !empty($newReleases)}
		{include file="frontend/components/monographListMultipress.tpl" monographs=$newReleases titleKey="catalog.newReleases" authorUserGroups=$authorUserGroups}
	{/if}
	
</div>

{include file="frontend/components/footer.tpl"}