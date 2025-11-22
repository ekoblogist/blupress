{**
 * plugins/generic/multipressIndex/templates/frontend/objects/monograph_summary_multipress.tpl
 *
 * Display a summary view of a monograph for multi-press display
 *}
{assign var=pressPath value=$monograph->getData('pressPath')}
{assign var=pressName value=$monograph->getData('pressName')}
{assign var=publication value=$monograph->getCurrentPublication()}

<div class="obj_monograph_summary{if $isFeatured} is_featured{/if}">
		<a href="{url press=$pressPath page="catalog" op="book" path=$monograph->getBestId()}" class="cover">
			{* Try to get cover image with locale fallback *}
			{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
			{assign var="coverUrl" value=""}
			
			{* If we have a cover in current locale *}
			{if $coverImage && $coverImage.uploadName}
				{assign var="coverUrl" value=$publication->getLocalizedCoverImageThumbnailUrl($monograph->getData('contextId'))}
			{else}
				{* Fallback: try all available locales *}
				{assign var="allCoverImages" value=$publication->getData('coverImage')}
				{if $allCoverImages}
					{foreach from=$allCoverImages key=locale item=localeImage}
						{if $localeImage && $localeImage.uploadName}
							{assign var="coverImage" value=$localeImage}
							{assign var="coverUrl" value=$publication->getLocalizedCoverImageThumbnailUrl($monograph->getData('contextId'), $locale)}
							{break}
						{/if}
					{/foreach}
				{/if}
			{/if}
			
			{if $coverUrl}
				<img
					src="{$coverUrl}"
					alt="{$coverImage.altText|escape|default:''}"
				>
			{/if}
		</a>
		{if $monograph->getSeriesPosition()}
			<div class="seriesPosition">
				{$monograph->getSeriesPosition()|escape}
			</div>
		{/if}
		<{$heading} class="title">
			<a href="{url press=$pressPath page="catalog" op="book" path=$monograph->getBestId()}">
				{$publication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}
			</a>
		</{$heading}>
		<div class="author">
			{$publication->getAuthorString($authorUserGroups, true)|escape}
		</div>
		{if $pressName}
			<div class="press">
				<a href="{url press=$pressPath}">
					{$pressName|escape}
				</a>
			</div>
		{/if}
		<div class="date">
			{$monograph->getDatePublished()|date_format:$dateFormatLong}
		</div>
</div><!-- .obj_monograph_summary -->