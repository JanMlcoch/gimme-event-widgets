<div class="sidebarEventDetail">
    {{^hasData}}
        <div class="loadingIcon">{{lang.loading}}</div>
    {{/hasData}}
    {{#hasData}}
    <div>
        <button type="button" class="eventDetailBackToEvents akcButton">< {{lang.backToList}}</button>
    </div>
    <div class="eventDetailHeader">
        <div class="eventDetailHeaderImage">

        </div>
        <div class="eventDetailHeaderBody">
            <h2>{{name}}</h2>
            <div class="eventDetailHeaderLeft">
                <div class="eventDetailPlace">
                    <img src="images/icons/map_point.png" class="eventDetailIcon eventDetailMapPoint" title="{{lang.doCenterMap}}">
                    <div class="floatLeft">
                        <span class="bold">{{place.name}}</span>
                        <span> ({{place.city}})</span>
                    </div>
                </div>
                <div class="eventDetailLink clear">
                    {{#hasWebpage}}
                    <img src="images/icons/home.png" class="eventDetailIcon" title="{{lang.webpageLink}}">
                    <div><a href="{{webpage}}">{{webpage}}</a></div>
                    {{/hasWebpage}}
                </div>
                <div class="eventDetailFb clear">
                    {{#hasFacebook}}
                    <img src="images/icons/fb.png" class="eventDetailIcon" title="{{lang.fbLink}}">
                    <div>{{lang.fbLink}}: <a target="_blank" href="{{facebook}}">{{facebook}}</a></div>
                    {{/hasFacebook}}
                </div>
                <div class="eventDetailSocial clear">
                    <div class="eventDetailFbPlugin">
                    </div>
                    <!--<img src="images/social.png" class="shift eventDetailIcon" title="{{lang.fbLink}}">-->
                </div>
            </div>
            <div class="eventDetailHeaderRight">
                <div class="eventDetailAttendBlock center-block">
                    <!--<div class="rating"></div>-->
                    <!--<div class="eventDetailRatingNumber">Hodnocení: {{userRating}}</div>-->
                    <button type="button" class="{{^logged}}disabled {{/logged}}{{#isPlanned}}positive {{/isPlanned}}akcButton eventDetailAttend">{{lang.attend}}</button>
                </div>
            </div>
        </div>
    </div>
    <div class="eventDetailLeft">
        <div class="eventDetailDate">
            <!--<div class="eventDetailFrom displayFlex"><div class="dateLabel">{{lang.from}}: </div>{{dateFrom}} </div>-->
            <!--<div class="eventDetailTo displayFlex"><div class="dateLabel">  {{lang.to}}: </div>{{dateTo}}</div>-->
            <div class="dateLabel">  {{lang.date}}: </div>{{dateFrom}}{{^dateToFromSame}} - {{dateTo}}{{/dateToFromSame}}
        </div>
        <div class="eventDetailTagsBlock">
            {{#tags}}
                <div class="eventDetailTag">{{name}}</div>
            {{/tags}}
        </div>
        <div class="eventDetailAnnotation">
            <p>
                {{annotation}}
            </p>
        </div>
        <div class="eventDetailDescription">
            {{#hasDescription}}
            <p>
                {{description}}
            </p>
            {{/hasDescription}}
        </div>

        <div class="eventDetailWidgetsBlock">
            <div class="eventDetailWidget">
                <div class="header">
                    <h3>{{lang.admission}}</h3>
                </div>
                <div class="content">
                    {{#admissions}}
                        <div title="{{description}}"><strong>{{flag}}: </strong> {{value}} {{currency}} </div>
                    {{/admissions}}
                    {{#hasAdmissionNote}}
                        <h4>{{lang.admissionNote}}</h4>
                        <div>{{admissionNote}}</div>
                    {{/hasAdmissionNote}}
                </div>
            </div>
            <div class="eventDetailWidget">
                <div class="header">
                    <h3>{{lang.organizer}}</h3>
                </div>
                <div class="content">
                    {{#organizers}}
                        <div><strong>{{name}}</strong></div>
                        <div class="shift">{{address}}</div>
                    {{/organizers}}
                    {{^organizers}}
                        {{lang.noOrganizers}}
                    {{/organizers}}
                </div>
            </div>
            <div class="eventDetailWidget">
                <div class="header">
                    <h3>{{lang.contactUs}}</h3>
                </div>
                <div class="content">
                    <div>{{lang.email}}: {{email}}</div>
                    <div>{{lang.phone}}: {{phone}}</div>
                    <div>{{contactWebpage}}</div>
                </div>
            </div>
            <div class="eventDetailSocial">
            </div>
        </div>
    </div>
    <div class="eventDetailRight">
        {{#logged}}
        <div class="eventDetailRatingBlock center-block">
            <button type="button" class="{{#recommendationIsPositivelyEvaluated}}positive {{/recommendationIsPositivelyEvaluated}}akcButton eventDetailRecommendedRight">{{lang.recommendedRight}}</button>
            <button type="button" class="{{#recommendationIsNegativelyEvaluated}}negative {{/recommendationIsNegativelyEvaluated}}akcButton eventDetailRecommendedWrong">{{lang.recommendedWrong}}</button>
        </div>
        {{/logged}}
        <div class="eventDetailAdvertisement">
            <a href="#">
                <img src="images/banner2.png" title="advertisement">
            </a>
        </div>

    </div>
    {{/hasData}}
</div>
