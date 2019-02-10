<h3>{{lang.eventCreateNewOrganizer}}</h3>
<div class="inputWithLabel col-md-6">
    <label for="eventOrganizerName">{{lang.eventOrganizerNameLabel}}</label>
    <input type="text" id="eventOrganizerName" class="eventLongInput" value="{{organizerName}}">
    <div class="errorMessage eventOrgNameValidatorMessage validatorMessage"></div>
</div>
<div class="inputWithLabel col-md-6">
    <label for="eventOrganizerId" class="eventLabelWidth">{{lang.eventOrganizerIdLabel}}</label>
    <input type="text" id="eventOrganizerId">
    <div class="errorMessage eventOrgIdValidatorMessage validatorMessage"></div>
</div>
<div class="clearfix"></div>
<div class="eventOrganizerDescriptionBlock inputWithLabel  col-md-6">
    <label for="eventOrganizerDescription" class="block">{{lang.eventOrganizerDescriptionLabel}}</label>
    <textarea id="eventOrganizerDescription" rows="4" cols="50"></textarea>
    <div class="errorMessage eventOrgDescriptionValidatorMessage validatorMessage"></div>
</div>
<div class="eventOrganizerContactBlock inputWithLabel  col-md-6">
    <label for="eventOrganizerContact" class="block">{{lang.eventOrganizerContactLabel}}</label>
    <textarea id="eventOrganizerContact" rows="4" cols="50"></textarea>
    <div class="errorMessage eventOrgContactValidatorMessage validatorMessage"></div>
</div>
<div class="clear inputWithLabel">
    <label for="eventOrganizerEmail">{{lang.eventOrganizerEmailLabel}}</label>
    <input type="text" id="eventOrganizerEmail" class="eventLongInput">
    <div class="errorMessage eventOrgEmailValidatorMessage validatorMessage"></div>
</div>
<div>
    <button type="button" class="akcButton">{{lang.eventOrganizerAddButton}}</button>
</div>