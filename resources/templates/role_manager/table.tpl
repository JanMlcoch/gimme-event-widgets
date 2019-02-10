<table>
  <thead>
  <tr>
    <th>Role</th>
    {{#permission_labels}}
      <th>{{.}}</th>
    {{/permission_labels}}
  </tr>
  </thead>
  <tbody>
  {{#roles}}
    <tr id="role_row_{{role}}" class="role-row">
      <td>{{role}}</td>
      {{#permissions}}
        <td><select class="role-permission-select" id="select_{{role}}_{{permission}}">
          {{#options}}
            <option {{selected}} class="role-permission-option-{{option}}" value="{{option}}">{{label}}</option>
          {{/options}}
        </select></td>
      {{/permissions}}
    </tr>
  {{/roles}}
  </tbody>
</table>