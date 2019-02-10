<div class="appCostCont">
    <div class="appErrorMessage">
    </div>
    <div class="priceCont floatLeft">
        <div class="priceLabel label">{{lang.eventAddAdmissionValueLabel}}</div>
        <input class="appPrice center-block" type="number" value="{{price}}" min="0" step="0.1">
    </div>
    <div class="currencyCont floatLeft">
        <div class="currencyLabel label">{{lang.eventAddAdmissionCurrencyLabel}}</div>
        <select class="appCurrency center-block">
            {{#currencies}}
                <option {{#selected}}selected{{/selected}} value="{{currency}}">
                    {{currency}}
                </option>
            {{/currencies}}
        </select>
    </div>
    <div class="flagCont floatLeft">
        <div class="flagLabel label">{{lang.eventAddAdmissionFlagLabel}}</div>
        <select class="appFlag center-block">
            {{#flags}}
                <option {{#selected}}selected{{/selected}} value="{{flag}}">
                    {{flagName}}
                </option>
            {{/flags}}
        </select>
    </div>
    <div class="floatLeft">
        <div class="label"></div>
        {{#priorityConflict}}
            <!--<div class="appPriorityCont" >-->
                <input type="checkbox" {{#priority}}checked{{/priority}} class="appPriority{{#hasColorClass}} {{colorClass}}{{/hasColorClass}}"/>
            <!--</div>-->
        {{/priorityConflict}}
    </div>
    <div class="descriptionCont floatLeft">
        <div class="descriptionLabel label">{{lang.eventAddAdmissionDescriptionLabel}}</div>
        <textarea class="appDescription" >{{description}}</textarea>
    </div>
    <!--<input type="button" class="appDestroy" value="X" />-->
    <div class="confirmCont floatLeft">
        <div class="label"></div>
        <button class="akcButton">{{lang.eventAddAdmissionButton}}</button>
    </div>
    <div class="clearfix"></div>
</div>