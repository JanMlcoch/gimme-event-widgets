<div class="modifyEventSocial col-md-12">
    <div class="eventPrivateBlock inputWithLabel">
        <label for="eventPrivate">{{lang.eventPrivateLabel}}</label>
        <input type="checkbox" id="eventPrivate">
        <div class="errorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLongLabel">
        <label for="eventSocialMaxParticipants">{{lang.eventSocialMaxParticipantsLabel}}</label>
        <input type="number" class="eventShortInput" id="eventSocialMaxParticipants" min="0" step="1">
        <div class="errorMessage eventMaxParticipantsValidatorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLongLabel">
        <label for="eventSocialExpectedParticipants">{{lang.eventSocialExpectedParticipantsLabel}}</label>
        <input type="number" class="eventShortInput" id="eventSocialExpectedParticipants" min="0" step="1">
        <div class="errorMessage eventExpectedParticipantsValidatorMessage validatorMessage"></div>
    </div>
    <div>
        <button type="button" class="akcButton small">{{lang.eventSocialInviteFriendsButton}}</button>
        <div class="errorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLabel">
        <label for="eventSocialFbLink">{{lang.eventSocialFbLinkLabel}}</label>
        <input type="text" class="eventLongInput"  id="eventSocialFbLink">
        <div class="errorMessage eventFbLinkValidatorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLabel">
        <label for="eventSocialGLink">{{lang.eventSocialGLinkLabel}}</label>
        <input type="text" class="eventLongInput"  id="eventSocialGLink">
        <div class="errorMessage eventGLinkValidatorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLabel">
        <label for="eventSocialTwitterLink">{{lang.eventSocialTwitterLinkLabel}}</label>
        <input type="text" class="eventLongInput"  id="eventSocialTwitterLink">
        <div class="errorMessage eventTwitterLinkValidatorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLabel">
        <label for="eventSocialPinterestLink">{{lang.eventSocialPinterestLinkLabel}}</label>
        <input type="text" class="eventLongInput"  id="eventSocialPinterestLink">
        <div class="errorMessage eventPinterestLinkValidatorMessage validatorMessage"></div>
    </div>
    <div class="inputWithLabel">
        <label for="eventSocialInstagramLink">{{lang.eventSocialInstagramLinkLabel}}</label>
        <input type="text" class="eventLongInput"  id="eventSocialInstagramLink">
        <div class="errorMessage eventInstagramLinkValidatorMessage validatorMessage"></div>
    </div>
    <div class="eventSocialNetworksBlock">
        <h2>{{lang.eventSocialNetworksLabel}}</h2>
        <div>{{lang.eventSocialNetworksGoogle}}</div>
      <div><span>{{lang.eventSocialNetworksFacebook}}</span>{{#hasFacebook}}
        <span>ID: {{facebook_id}}</span>{{/hasFacebook}}</div>
        <div>{{lang.eventSocialNetworksFlickr}}</div>
    </div>
    <div class="inputWithLabel hidden">
        <label for="eventVideo">{{lang.eventVideoLabel}}</label>
        <input type="checkbox" id="eventVideo">
    </div>
</div>
