{{#emptyChildren}}
    <div class="loadingIcon">
        loading ... <br>
        <i class="w3-xlarge glyphicon glyphicon-refresh w3-spin"></i>
    </div>
{{/emptyChildren}}
<div class="recommendedEvents">
    {{#showBestRecommendation}}
        <h2 class="recommendedHeading">{{lang.bestRecommendation}}</h2>
        <div>
            {{#bestRecommendation}}
                <div class="sidebarEvent" id="event_{{.}}"></div>
            {{/bestRecommendation}}
        </div>
    {{/showBestRecommendation}}
    {{#showGoodRecommendation}}
        <h2 class="clear recommendedHeading">{{lang.goodRecommendation}}</h2>
        <div>
            {{#goodRecommendation}}
                <div class="sidebarEvent" id="event_{{.}}"></div>
            {{/goodRecommendation}}
        </div>
    {{/showGoodRecommendation}}
    {{#showCasualRecommendation}}
        <h2 class="clear recommendedHeading">{{lang.casualRecommendation}}</h2>
        <div>
            {{#casualRecommendtaion}}
                <div class="sidebarEvent" id="event_{{.}}"></div>
            {{/casualRecommendtaion}}
        </div>
    {{/showCasualRecommendation}}
</div>
