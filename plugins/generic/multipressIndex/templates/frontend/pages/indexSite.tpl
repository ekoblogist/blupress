{**
 * plugins/generic/multipressIndex/templates/frontend/pages/indexSite.tpl
 *
 * Site index - displaying new releases from all presses
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
		{include file=$monographListTemplate monographs=$newReleases titleKey="catalog.newReleases" authorUserGroups=$authorUserGroups}
		
		{* Pagination matching default theme style *}
		{if $totalPages > 1}
			{assign var="prevPage" value=$currentPage-1}
			{assign var="nextPage" value=$currentPage+1}
			
			<div class="cmp_pagination" aria-label="{translate|escape key="common.pagination.label"}">
				{if $currentPage > 1}
					<a class="prev" href="{$baseUrl}/index.php/index?page={$prevPage}">{translate key="help.previous"}</a>
				{/if}
				<span class="current">
					{translate key="common.pagination" start=$showingStart end=$showingEnd total=$totalCount}
				</span>
				{if $currentPage < $totalPages}
					<a class="next" href="{$baseUrl}/index.php/index?page={$nextPage}">{translate key="help.next"}</a>
				{/if}
			</div>
		{/if}
	{/if}
	
</div>
{include file="frontend/components/footer.tpl"}