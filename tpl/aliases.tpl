[% INCLUDE header.tpl %]
    <div id="main" class="datatable_container">
		[% FOREACH line IN aliases %]
		[% IF loop.first %]
		<table id="datatable">
			<thead>
			<tr>
				<th>[% "Alias" | l10n %]</th>
				<th>[% "Target" | l10n %]</th>
				<th>[% "Active" | l10n %]</th>
				<th></th>
				<th></th>
			</tr>
			</thead>
			<tbody>
		[% END %]
			<tr>
				<td>
					<a href="[% base_url %]?rm=edit_alias&alias_id=[% line.id %]">[% line.local_part | highlight(search) %]@[% line.domain | highlight(search) %]</a>
				</td>
				<td>
					[% line.goto.substr(0,60) | highlight(search) %]
				</td>
				<td>
					[% IF line.is_active == 1 %]
					<a href="[% base_url %]?rm=update_alias&alias_id=[% line.id %]&is_active=0">[% "Yes" | l10n %]</a>
					[% ELSE %]
					<a href="[% base_url %]?rm=update_alias&alias_id=[% line.id %]&is_active=1">[% "No" | l10n %]</a>
					[% END %]
				</td>
				<td>
					<a href="[% base_url %]?rm=edit_alias&alias_id=[% line.id %]">[% "edit" | l10n %]</a>
				</td>
				<td>
					<a onClick="if(confirm('[% "Do you really want to delete the Account [_1]?" | l10n(line.local_part _ '@' _ line.domain) %]')) return true; else return false;" href="[% base_url %]?rm=remove_alias&alias_id=[% line.id %]">[% "del" | l10n %]</a>
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
		<a href="[% base_url %]?rm=create_alias"><img src="[% media_prefix %]/icons/fffsilk/add.png" border="0" /> [% "Add Alias" | l10n %]</a>
    </div>
[% INCLUDE footer.tpl %]
