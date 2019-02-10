<div class="centralBlock center-block test-manager">
  <a><h2 id="test_manager_heading">Test manager</h2></a>
  {{#groups}}
    <a class="test-manager-group" id="test_manager_group_{{simple}}">{{name}}</a>
    <div class="test-manager-line">
      {{#tests}}
        <div id="test_manager_{{simple}}" class="test-manager-button {{style}}">{{name}}
          {{#haveResult}}
            <div class="test-manager-result">
              <b>{{firstLine}}</b>{{#resultLines}}<br>{{.}}{{/resultLines}}
            </div>
          {{/haveResult}}
          {{#haveDescription}}
            <div class="test-manager-description">{{description}}</div>
          {{/haveDescription}}
        </div>
      {{/tests}}
    </div>
  {{/groups}}
</div>