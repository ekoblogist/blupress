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
	{/if}
	
</div>

{include file="frontend/components/footer.tpl"}