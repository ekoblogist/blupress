<?php

/**
 * @defgroup pages_header Header page
 */

/**
 * @file pages/index/index.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @ingroup pages_index
 *
 * @brief Handle site index page requests.
 *
 */


switch ($op) {
    case 'index':
        define('HANDLER_CLASS', 'APP\pages\index\IndexHandler');
        break;
}
