{**
    * plugins/generic/multipressIndex/templates/frontend/pages/indexSite.tpl
    *
    * Site index - displaying new releases from all presses
    *}
   {include file="frontend/components/header.tpl"}
   
   {* Load pagination CSS *}
   <link rel="stylesheet" href="{$baseUrl}/plugins/generic/multipressIndex/styles/pagination.css" type="text/css" />
   
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
   		
   		{* Pagination *}
   		{if $totalPages > 1}
   			<div class="cmp_pagination">
   				<ul class="pagination_links">
   					{if $currentPage > 1}
   						<li class="prev">
   							<a href="{url page="index" op="index" params=['page' => ($currentPage - 1)]}">
   								{translate key="help.previous"}
   							</a>
   						</li>
   					{/if}
   					
   					{for $i=1 to $totalPages}
   						{if $i == $currentPage}
   							<li class="current">
   								<span>{$i}</span>
   							</li>
   						{else}
   							<li>
   								<a href="{url page="index" op="index" params=['page' => $i]}">
   									{$i}
   								</a>
   							</li>
   						{/if}
   					{/for}
   					
   					{if $currentPage < $totalPages}
   						<li class="next">
   							<a href="{url page="index" op="index" params=['page' => ($currentPage + 1)]}">
   								{translate key="help.next"}
   							</a>
   						</li>
   					{/if}
   				</ul>
   			</div>
   		{/if}
   	{/if}
   	
   </div>
   {include file="frontend/components/footer.tpl"}