[% INCLUDE header.tpl %]
    <div id="main">
	    <div id="overview">
			Search:
			<form name="search" method="GET" action="vboxadm.pl">
			<input type="hidden" name="rm" value="domain_aliases" />
			<input type="textbox" name="search" size="10" value="[% search %]" />
			</form>
		</div>
		[% FOREACH line IN domains %]
		[% IF loop.first %]
		<table class="sortable hilight">
			<thead>
			<tr>
				<th>Domain</th>
				<th>Target</th>
				<th>Active</th>
				<th></th>
				<th></th>
			</tr>
			</thead>
			<tbody>
		[% END %]
			<tr>
				<td>
					[% line.name | highlight(search) %]
				</td>
				<td>
					[% line.target | highlight(search) %]
				</td>
				<td>
					[% IF line.is_active == 1 %]
					<a href="vboxadm.pl?rm=update_domain_alias&domain_alias_id=[% line.id %]&is_active=0">Yes</a>
					[% ELSE %]
					<a href="vboxadm.pl?rm=update_domain_alias&domain_alias_id=[% line.id %]&is_active=1">No</a>
					[% END %]
				</td>
				<td>
					<a href="vboxadm.pl?rm=edit_domain_alias&domain_alias_id=[% line.id %]">edit</a>
				</td>
				<td>
					<a onClick="if(confirm('Do you really want to delete the Account [% line.name %]?')) return true; else return false;" href="vboxadm.pl?rm=remove_domain_alias&domain_alias_id=[% line.id %]">del</a>
				</td>
			</tr>
		[% IF loop.last %]
		</tbody>
		<tfoot>
		</tfoot>
		</table>
		[% END %]
		[% END %]
		<br />
		<a href="vboxadm.pl?rm=create_domain_alias">Add Domain Alias</a>
    </div>
[% INCLUDE footer.tpl %]
