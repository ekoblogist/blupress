{**
 * templates/frontend/components/monographListMultipress.tpl
 *
 * Display a list of monographs from multiple presses
 *
 * @uses $monographs array List of monographs to display
 * @uses $titleKey string Optional translation key for a title for the list
 * @uses $heading string HTML heading element, default: h2
 * @uses $authorUserGroups Traversable Author user groups
 *}
{if !$heading}
	{assign var="heading" value="h2"}
{/if}
{if !$titleKey}
	{assign var="monographHeading" value=$heading}
{elseif $heading == 'h2'}
	{assign var="monographHeading" value="h3"}
{elseif $heading == 'h3'}
	{assign var="monographHeading" value="h4"}
{else}
	{assign var="monographHeading" value="h5"}
{/if}
<div class="cmp_monographs_list">
	{* Optional title *}
	{if $titleKey}
		<{$heading} class="title">
			{translate key=$titleKey}
		</{$heading}>
	{/if}
	{assign var=counter value=1}
	{foreach name="monographListLoop" from=$monographs item=monograph}
		{if $counter is odd by 1}
			<div class="row">
		{/if}
			{include file="frontend/objects/monograph_summary_multipress.tpl" monograph=$monograph isFeatured=false heading=$monographHeading authorUserGroups=$authorUserGroups}
		{if $counter is even by 1}
			</div>
		{/if}
		{assign var=counter value=$counter+1}
	{/foreach}
	{* Close .row if we have an odd number of titles *}
	{if $counter > 1 && $counter is even by 1}
		</div>
	{/if}
</div>