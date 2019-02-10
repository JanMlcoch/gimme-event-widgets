<div class="modifyEventExtended col-md-12">
    <div class="eventQuickOrganizerBlock inputWithLabel">
        <label for="eventQuickOrganizer">{{lang.eventQuickOrganizerLabel}}</label>
        <input type="text" class="eventLongInput" id="eventQuickOrganizer"/>
        <button type="button" class="hidden">{{lang.eventQuickOrganizerCreateButton}}</button>
        {{#organizers}}
            <div class="eventOrganizerDetail">
                {{name}}<br>
                {{adress}}
            </div>
        {{/organizers}}
        <div class="errorMessage eventToTimeValidatorMessage validatorMessage"></div>
    </div>
    <div class="eventDescriptionBlock block">
        <label for="eventDescription">{{lang.eventDescriptionLabel}}</label>
        <img class="addEventEditIcon" src="{{editImageSRC}}" title="{{lang.eventDescriptionTitle}}">
        <textarea class="block" id="eventDescription" rows="4" cols="100">{{description}}</textarea>
        <div class="errorMessage eventToTimeValidatorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLabel">
        <label for="appManageEventExtendedLanguage">{{lang.eventLanguageLabel}}</label>
        <select id="appManageEventExtendedLanguage">
            {{#languages}}
                <option value="{{.}}">{{.}}</option>
            {{/languages}}
        </select>
        <div class="errorMessage eventToTimeValidatorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLabel col-md-6">
        <label for="eventFbEvent">{{lang.eventFbEventLabel}}</label>
        <input type="text" id="eventFbEvent" value="{{fbEvent}}">
        <div class="eventFbEventValidatorMessage errorMessage"></div>
    </div>
    <div class="inputWithLabel col-md-6">
        <label for="eventWebpage">{{lang.eventWebpageLabel}}</label>
        <input type="text" id="eventWebpage" value="{{webpage}}">
        <div class="eventWebpageValidatorMessage errorMessage"></div>
    </div>
    <div class="eventPhysicalDemandBlock">
        <label for="eventPhysicalDemands">{{lang.eventPhysicalDemandsLabel}}</label>
        <select id="eventPhysicalDemands">
            <option value="1">{{lang.eventPhysicalDemand1}}</option>
            <option value="2">{{lang.eventPhysicalDemand2}}</option>
            <option value="3">{{lang.eventPhysicalDemand3}}</option>
            <option value="4">{{lang.eventPhysicalDemand4}}</option>
            <option value="5">{{lang.eventPhysicalDemand5}}</option>
            <option value="6">{{lang.eventPhysicalDemand6}}</option>
        </select>
    </div>
</div>
