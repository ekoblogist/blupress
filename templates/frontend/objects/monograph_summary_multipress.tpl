{**
 * templates/frontend/objects/monograph_summary_multipress.tpl
 *
 * Display a summary view of a monograph for multi-press display
 *
 * @uses $monograph Monograph The monograph to be displayed
 * @uses $authorUserGroups Traversible The set of author user groups
 * @uses $isFeatured bool Is this a featured monograph?
 *}
{assign var=pressPath value=$monograph->getData('pressPath')}
{assign var=pressName value=$monograph->getData('pressName')}

<div class="obj_monograph_summary{if $isFeatured} is_featured{/if}">
		<a href="{url press=$pressPath page="catalog" op="book" path=$monograph->getBestId()}" class="cover">
			{assign var="coverImage" value=$monograph->getCurrentPublication()->getLocalizedData('coverImage')}
			<img
				src="{$monograph->getCurrentPublication()->getLocalizedCoverImageThumbnailUrl($monograph->getData('contextId'))}"
				alt="{$coverImage.altText|escape|default:''}"
			>
		</a>
		{if $monograph->getSeriesPosition()}
			<div class="seriesPosition">
				{$monograph->getSeriesPosition()|escape}
			</div>
		{/if}
		<{$heading} class="title">
			<a href="{url press=$pressPath page="catalog" op="book" path=$monograph->getBestId()}">
				{$monograph->getCurrentPublication()->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}
			</a>
		</{$heading}>
		<div class="author">
			{$monograph->getCurrentPublication()->getAuthorString($authorUserGroups, true)|escape}
		</div>
		<div class="date">
			{$monograph->getDatePublished()|date_format:$dateFormatLong}
		</div>
        {if $pressName}
			<div class="press">
				<a href="{url press=$pressPath}">
					{$pressName|escape}
				</a>
			</div>
		{/if}
</div><!-- .obj_monograph_summary -->