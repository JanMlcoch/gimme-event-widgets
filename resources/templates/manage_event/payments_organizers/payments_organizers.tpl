<div class="modifyEventAdmission col-md-12">
    <h2>{{lang.eventAdmissionHeading}}</h2>
    <div class="eventUsedAdmissionsBlock">
        {{#admissions}}
            <div class="eventAdmissionDetail" id="{{costFlagId}}">
                <div class="eventCostFlagCont"><strong>{{flag}}</strong> &nbsp;&nbsp;&nbsp;</div>
                {{price}} &nbsp;
                {{currency}} &nbsp;
                <span class="eventAdmissionDescription">{{description}}</span>
                <button type="button" class="edit akcButton small">{{lang.eventAdmissionEditButton}}</button>
                <button type="button" class="remove akcButton small">{{lang.eventAdmissionRemoveButton}}</button>
            </div>
        {{/admissions}}
    </div>
    <div class="eventAdmissionsBlock shift">
        <div class="appManageCostsTarget">
            <button type="button" class="addAdmission akcButton">{{lang.eventAddAdmission}}</button>
        </div>

    <!--</div>-->
    <!--<h2>{{lang.eventAddAdmission}}</h2>-->
    <!--<div>-->
        <!--<label for="eventAddAdmissionFlag">{{lang.eventAddAdmissionFlagLabel}}</label>-->
        <!--<select id="eventAddAdmissionFlag">-->
            <!--{{#admissionFlags}}-->
            <!--<option value="{{.}}"></option>-->
            <!--{{/admissionFlags}}-->
        <!--</select>-->
    <!--</div>-->
    <!--<div>-->
        <!--<label for="eventAddAdmissionValue">{{lang.eventAddAdmissionValueLabel}}</label>-->
        <!--<input type="text" id="eventAddAdmissionValue">-->
    <!--</div>-->
    <!--<div>-->
        <!--<div><label for="eventAddAdmissionCurrency">{{lang.eventAddAdmissionCurrencyLabel}}</label></div>-->
        <!--<select id="eventAddAdmissionCurrency">-->
            <!--{{#admissionCurrencies}}-->
            <!--<option value="{{.}}"></option>-->
            <!--{{/admissionCurrencies}}-->
        <!--</select>-->
    <!--</div>-->
    <!--<div>-->
        <!--<button>{{lang.eventAddAdmissionButton}}</button>-->
    </div>

    <h2 class="eventOrganizerHeading">{{lang.eventOrganizerHeading}}</h2>

    <div class="eventOrganizerBlock inputWithLabel">
        <label for="eventOrganizer">{{lang.eventOrganizerLabel}}</label>
        <input type="text" id="eventOrganizer" class="eventLongInput" placeholder="{{lang.eventOrganizerFindOrganizer}}"/>
        <div class="errorMessage eventOrganizerValidatorMessage validatorMessage"></div>
    </div>
    <div class="eventUsedOrganizersBlock">
        {{#organizers}}
            <div class="eventOrganizerDetail">
                {{name}}, &nbsp;&nbsp;&nbsp;
                {{flag}}
                <button type="button" class="edit akcButton small">{{lang.eventOrganizerEditButton}}</button>
                <button type="button" class="edit akcButton small">{{lang.eventOrganizerRemoveButton}}</button>
            </div>
        {{/organizers}}
    </div>
    <div class="eventNewOrganizer shift">
        <button type="button" class="addOrganizer akcButton">{{lang.eventCreateNewOrganizer}}</button>
    </div>
</div>
