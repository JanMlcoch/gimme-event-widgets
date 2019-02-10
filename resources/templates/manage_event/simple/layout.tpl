<div class="appAddEventWidgetCont">
    <div class="manageEventTabs">
        <button type="button" class="tabLabel akcButton manageEventBase" data-id="base">{{lang.base}}</button>
        <button type="button" class="tabLabel akcButton manageEventExtended" data-id="extended">{{lang.extended}}</button>
        <button type="button" class="tabLabel akcButton manageEventSocial" data-id="social">{{lang.social}}</button>
        <button type="button" class="tabLabel akcButton manageEventGallery disabled" data-id="gallery">{{lang.gallery}}</button>
      <button type="button" class="tabLabel akcButton manageFacebookEvent"
              data-id="facebook">{{lang.facebookTab}}</button>
    </div>

    {{#displayCreateSuccessfull}}
        <div class="infoBlock successful createSuccessFull">
            {{lang.createSuccessFull}}
            <button type="button" class="newEvent">{{lang.newEvent}}</button>
        </div>
    {{/displayCreateSuccessfull}}
    {{#displayCreateError}}
        <div class="infoBlock failed createError">
            {{errorMessage}}
            <button type="button" class="continueEditing">{{lang.returnToEdit}}</button>
        </div>
    {{/displayCreateError}}
    <div class="manageEventScroll">
        <div class="manageEventContent"></div>
        <button type="button" class="sendButtonDisabled akcButton saveEventButton">{{lang.save}}</button>
    </div>
</div>
