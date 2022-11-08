{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "65f47675",
   "metadata": {
    "papermill": {
     "duration": 0.005929,
     "end_time": "2022-11-08T20:14:53.555976",
     "exception": false,
     "start_time": "2022-11-08T20:14:53.550047",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "### <center>Stats 5600 - Final Project</center>\n",
    "# <center>Customer Lifetime Value Prediction</center>\n",
    "#### Sujan Barama\n",
    "#### Thejas Kiran"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "de71a9b5",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:14:53.570482Z",
     "iopub.status.busy": "2022-11-08T20:14:53.567842Z",
     "iopub.status.idle": "2022-11-08T20:14:53.767893Z",
     "shell.execute_reply": "2022-11-08T20:14:53.766085Z"
    },
    "papermill": {
     "duration": 0.210688,
     "end_time": "2022-11-08T20:14:53.771216",
     "exception": false,
     "start_time": "2022-11-08T20:14:53.560528",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘dplyr’\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:stats’:\n",
      "\n",
      "    filter, lag\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:base’:\n",
      "\n",
      "    intersect, setdiff, setequal, union\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "library(dplyr)\n",
    "library(jsonlite)\n",
    "library(stringr)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "9ee44a66",
   "metadata": {
    "_cell_guid": "b1076dfc-b9ad-4769-8c92-a6c4dae69d19",
    "_uuid": "8f2839f25d086af736a60e9eeb907d3b93b6e0e5",
    "execution": {
     "iopub.execute_input": "2022-11-08T20:14:53.813868Z",
     "iopub.status.busy": "2022-11-08T20:14:53.782812Z",
     "iopub.status.idle": "2022-11-08T20:14:59.056770Z",
     "shell.execute_reply": "2022-11-08T20:14:59.054849Z"
    },
    "papermill": {
     "duration": 5.283034,
     "end_time": "2022-11-08T20:14:59.059315",
     "exception": false,
     "start_time": "2022-11-08T20:14:53.776281",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "data <- read.csv('../input/ga-customer-revenue-prediction/train_v2.csv', nrows = 10000)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "e47ad130",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:14:59.077355Z",
     "iopub.status.busy": "2022-11-08T20:14:59.074712Z",
     "iopub.status.idle": "2022-11-08T20:14:59.097157Z",
     "shell.execute_reply": "2022-11-08T20:14:59.095075Z"
    },
    "papermill": {
     "duration": 0.033858,
     "end_time": "2022-11-08T20:14:59.099986",
     "exception": false,
     "start_time": "2022-11-08T20:14:59.066128",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "10000"
      ],
      "text/latex": [
       "10000"
      ],
      "text/markdown": [
       "10000"
      ],
      "text/plain": [
       "[1] 10000"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "nrow(data)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "b520f443",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:14:59.112774Z",
     "iopub.status.busy": "2022-11-08T20:14:59.111305Z",
     "iopub.status.idle": "2022-11-08T20:14:59.149479Z",
     "shell.execute_reply": "2022-11-08T20:14:59.146794Z"
    },
    "papermill": {
     "duration": 0.047645,
     "end_time": "2022-11-08T20:14:59.152346",
     "exception": false,
     "start_time": "2022-11-08T20:14:59.104701",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 13</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>channelGrouping</th><th scope=col>customDimensions</th><th scope=col>date</th><th scope=col>device</th><th scope=col>fullVisitorId</th><th scope=col>geoNetwork</th><th scope=col>hits</th><th scope=col>socialEngagementType</th><th scope=col>totals</th><th scope=col>trafficSource</th><th scope=col>visitId</th><th scope=col>visitNumber</th><th scope=col>visitStartTime</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>Organic Search</td><td>[{'index': '4', 'value': 'EMEA'}]</td><td>20171016</td><td>{\"browser\": \"Firefox\", \"browserVersion\": \"not available in demo dataset\", \"browserSize\": \"not available in demo dataset\", \"operatingSystem\": \"Windows\", \"operatingSystemVersion\": \"not available in demo dataset\", \"isMobile\": false, \"mobileDeviceBranding\": \"not available in demo dataset\", \"mobileDeviceModel\": \"not available in demo dataset\", \"mobileInputSelector\": \"not available in demo dataset\", \"mobileDeviceInfo\": \"not available in demo dataset\", \"mobileDeviceMarketingName\": \"not available in demo dataset\", \"flashVersion\": \"not available in demo dataset\", \"language\": \"not available in demo dataset\", \"screenColors\": \"not available in demo dataset\", \"screenResolution\": \"not available in demo dataset\", \"deviceCategory\": \"desktop\"}</td><td>3.162356e+18</td><td>{\"continent\": \"Europe\", \"subContinent\": \"Western Europe\", \"country\": \"Germany\", \"region\": \"not available in demo dataset\", \"metro\": \"not available in demo dataset\", \"city\": \"not available in demo dataset\", \"cityId\": \"not available in demo dataset\", \"networkDomain\": \"(not set)\", \"latitude\": \"not available in demo dataset\", \"longitude\": \"not available in demo dataset\", \"networkLocation\": \"not available in demo dataset\"}</td><td>[{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExit': True, 'referer': 'https://www.google.co.uk/search?q=water+bottle&amp;ie=utf-8&amp;num=100&amp;oe=utf-8&amp;hl=en&amp;gl=GB&amp;uule=w+CAIQIFISCamRx0IRO1oCEXoliDJDoPjE&amp;glp=1&amp;gws_rd=cr&amp;fg=1', 'page': {'pagePath': '/google+redesign/bags/water+bottles+and+tumblers', 'hostname': 'shop.googlemerchandisestore.com', 'pageTitle': 'Water Bottles &amp; Tumblers | Drinkware | Google Merchandise Store', 'pagePathLevel1': '/google+redesign/', 'pagePathLevel2': '/bags/', 'pagePathLevel3': '/water+bottles+and+tumblers', 'pagePathLevel4': ''}, 'transaction': {'currencyCode': 'USD'}, 'item': {'currencyCode': 'USD'}, 'appInfo': {'screenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'landingScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'exitScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'screenDepth': '0'}, 'exceptionInfo': {'isFatal': True}, 'product': [{'productSKU': 'GGOEGDHC074099', 'v2ProductName': 'Google 17oz Stainless Steel Sport Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '23990000', 'localProductPrice': '23990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '1'}, {'productSKU': 'GGOEGDHQ015399', 'v2ProductName': '26 oz Double Wall Insulated Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '24990000', 'localProductPrice': '24990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '2'}, {'productSKU': 'GGOEYDHJ056099', 'v2ProductName': '22 oz YouTube Bottle Infuser', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '4990000', 'localProductPrice': '4990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '3'}, {'productSKU': 'GGOEGAAX0074', 'v2ProductName': 'Google 22 oz Water Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '2990000', 'localProductPrice': '2990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '4'}], 'promotion': [], 'eCommerceAction': {'action_type': '0', 'step': '1'}, 'experiment': [], 'customVariables': [], 'customDimensions': [], 'customMetrics': [], 'type': 'PAGE', 'social': {'socialNetwork': '(not set)', 'hasSocialSourceReferral': 'No', 'socialInteractionNetworkAction': ' : '}, 'contentGroup': {'contentGroup1': '(not set)', 'contentGroup2': 'Bags', 'contentGroup3': '(not set)', 'contentGroup4': '(not set)', 'contentGroup5': '(not set)', 'previousContentGroup1': '(entrance)', 'previousContentGroup2': '(entrance)', 'previousContentGroup3': '(entrance)', 'previousContentGroup4': '(entrance)', 'previousContentGroup5': '(entrance)', 'contentGroupUniqueViews2': '1'}, 'dataSource': 'web', 'publisher_infos': []}]</td><td>Not Socially Engaged</td><td>{\"visits\": \"1\", \"hits\": \"1\", \"pageviews\": \"1\", \"bounces\": \"1\", \"newVisits\": \"1\", \"sessionQualityDim\": \"1\"}</td><td>{\"campaign\": \"(not set)\", \"source\": \"google\", \"medium\": \"organic\", \"keyword\": \"water bottle\", \"adwordsClickInfo\": {\"criteriaParameters\": \"not available in demo dataset\"}}</td><td>1508198450</td><td>1</td><td>1508198450</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 13\n",
       "\\begin{tabular}{r|lllllllllllll}\n",
       "  & channelGrouping & customDimensions & date & device & fullVisitorId & geoNetwork & hits & socialEngagementType & totals & trafficSource & visitId & visitNumber & visitStartTime\\\\\n",
       "  & <chr> & <chr> & <int> & <chr> & <dbl> & <chr> & <chr> & <chr> & <chr> & <chr> & <int> & <int> & <int>\\\\\n",
       "\\hline\n",
       "\t1 & Organic Search & {[}\\{'index': '4', 'value': 'EMEA'\\}{]} & 20171016 & \\{\"browser\": \"Firefox\", \"browserVersion\": \"not available in demo dataset\", \"browserSize\": \"not available in demo dataset\", \"operatingSystem\": \"Windows\", \"operatingSystemVersion\": \"not available in demo dataset\", \"isMobile\": false, \"mobileDeviceBranding\": \"not available in demo dataset\", \"mobileDeviceModel\": \"not available in demo dataset\", \"mobileInputSelector\": \"not available in demo dataset\", \"mobileDeviceInfo\": \"not available in demo dataset\", \"mobileDeviceMarketingName\": \"not available in demo dataset\", \"flashVersion\": \"not available in demo dataset\", \"language\": \"not available in demo dataset\", \"screenColors\": \"not available in demo dataset\", \"screenResolution\": \"not available in demo dataset\", \"deviceCategory\": \"desktop\"\\} & 3.162356e+18 & \\{\"continent\": \"Europe\", \"subContinent\": \"Western Europe\", \"country\": \"Germany\", \"region\": \"not available in demo dataset\", \"metro\": \"not available in demo dataset\", \"city\": \"not available in demo dataset\", \"cityId\": \"not available in demo dataset\", \"networkDomain\": \"(not set)\", \"latitude\": \"not available in demo dataset\", \"longitude\": \"not available in demo dataset\", \"networkLocation\": \"not available in demo dataset\"\\} & {[}\\{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExit': True, 'referer': 'https://www.google.co.uk/search?q=water+bottle\\&ie=utf-8\\&num=100\\&oe=utf-8\\&hl=en\\&gl=GB\\&uule=w+CAIQIFISCamRx0IRO1oCEXoliDJDoPjE\\&glp=1\\&gws\\_rd=cr\\&fg=1', 'page': \\{'pagePath': '/google+redesign/bags/water+bottles+and+tumblers', 'hostname': 'shop.googlemerchandisestore.com', 'pageTitle': 'Water Bottles \\& Tumblers \\textbar{} Drinkware \\textbar{} Google Merchandise Store', 'pagePathLevel1': '/google+redesign/', 'pagePathLevel2': '/bags/', 'pagePathLevel3': '/water+bottles+and+tumblers', 'pagePathLevel4': ''\\}, 'transaction': \\{'currencyCode': 'USD'\\}, 'item': \\{'currencyCode': 'USD'\\}, 'appInfo': \\{'screenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'landingScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'exitScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'screenDepth': '0'\\}, 'exceptionInfo': \\{'isFatal': True\\}, 'product': {[}\\{'productSKU': 'GGOEGDHC074099', 'v2ProductName': 'Google 17oz Stainless Steel Sport Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '23990000', 'localProductPrice': '23990000', 'isImpression': True, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'productListName': 'Category', 'productListPosition': '1'\\}, \\{'productSKU': 'GGOEGDHQ015399', 'v2ProductName': '26 oz Double Wall Insulated Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '24990000', 'localProductPrice': '24990000', 'isImpression': True, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'productListName': 'Category', 'productListPosition': '2'\\}, \\{'productSKU': 'GGOEYDHJ056099', 'v2ProductName': '22 oz YouTube Bottle Infuser', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '4990000', 'localProductPrice': '4990000', 'isImpression': True, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'productListName': 'Category', 'productListPosition': '3'\\}, \\{'productSKU': 'GGOEGAAX0074', 'v2ProductName': 'Google 22 oz Water Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '2990000', 'localProductPrice': '2990000', 'isImpression': True, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'productListName': 'Category', 'productListPosition': '4'\\}{]}, 'promotion': {[}{]}, 'eCommerceAction': \\{'action\\_type': '0', 'step': '1'\\}, 'experiment': {[}{]}, 'customVariables': {[}{]}, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'type': 'PAGE', 'social': \\{'socialNetwork': '(not set)', 'hasSocialSourceReferral': 'No', 'socialInteractionNetworkAction': ' : '\\}, 'contentGroup': \\{'contentGroup1': '(not set)', 'contentGroup2': 'Bags', 'contentGroup3': '(not set)', 'contentGroup4': '(not set)', 'contentGroup5': '(not set)', 'previousContentGroup1': '(entrance)', 'previousContentGroup2': '(entrance)', 'previousContentGroup3': '(entrance)', 'previousContentGroup4': '(entrance)', 'previousContentGroup5': '(entrance)', 'contentGroupUniqueViews2': '1'\\}, 'dataSource': 'web', 'publisher\\_infos': {[}{]}\\}{]} & Not Socially Engaged & \\{\"visits\": \"1\", \"hits\": \"1\", \"pageviews\": \"1\", \"bounces\": \"1\", \"newVisits\": \"1\", \"sessionQualityDim\": \"1\"\\} & \\{\"campaign\": \"(not set)\", \"source\": \"google\", \"medium\": \"organic\", \"keyword\": \"water bottle\", \"adwordsClickInfo\": \\{\"criteriaParameters\": \"not available in demo dataset\"\\}\\} & 1508198450 & 1 & 1508198450\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 13\n",
       "\n",
       "| <!--/--> | channelGrouping &lt;chr&gt; | customDimensions &lt;chr&gt; | date &lt;int&gt; | device &lt;chr&gt; | fullVisitorId &lt;dbl&gt; | geoNetwork &lt;chr&gt; | hits &lt;chr&gt; | socialEngagementType &lt;chr&gt; | totals &lt;chr&gt; | trafficSource &lt;chr&gt; | visitId &lt;int&gt; | visitNumber &lt;int&gt; | visitStartTime &lt;int&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 1 | Organic Search | [{'index': '4', 'value': 'EMEA'}] | 20171016 | {\"browser\": \"Firefox\", \"browserVersion\": \"not available in demo dataset\", \"browserSize\": \"not available in demo dataset\", \"operatingSystem\": \"Windows\", \"operatingSystemVersion\": \"not available in demo dataset\", \"isMobile\": false, \"mobileDeviceBranding\": \"not available in demo dataset\", \"mobileDeviceModel\": \"not available in demo dataset\", \"mobileInputSelector\": \"not available in demo dataset\", \"mobileDeviceInfo\": \"not available in demo dataset\", \"mobileDeviceMarketingName\": \"not available in demo dataset\", \"flashVersion\": \"not available in demo dataset\", \"language\": \"not available in demo dataset\", \"screenColors\": \"not available in demo dataset\", \"screenResolution\": \"not available in demo dataset\", \"deviceCategory\": \"desktop\"} | 3.162356e+18 | {\"continent\": \"Europe\", \"subContinent\": \"Western Europe\", \"country\": \"Germany\", \"region\": \"not available in demo dataset\", \"metro\": \"not available in demo dataset\", \"city\": \"not available in demo dataset\", \"cityId\": \"not available in demo dataset\", \"networkDomain\": \"(not set)\", \"latitude\": \"not available in demo dataset\", \"longitude\": \"not available in demo dataset\", \"networkLocation\": \"not available in demo dataset\"} | [{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExit': True, 'referer': 'https://www.google.co.uk/search?q=water+bottle&amp;ie=utf-8&amp;num=100&amp;oe=utf-8&amp;hl=en&amp;gl=GB&amp;uule=w+CAIQIFISCamRx0IRO1oCEXoliDJDoPjE&amp;glp=1&amp;gws_rd=cr&amp;fg=1', 'page': {'pagePath': '/google+redesign/bags/water+bottles+and+tumblers', 'hostname': 'shop.googlemerchandisestore.com', 'pageTitle': 'Water Bottles &amp; Tumblers | Drinkware | Google Merchandise Store', 'pagePathLevel1': '/google+redesign/', 'pagePathLevel2': '/bags/', 'pagePathLevel3': '/water+bottles+and+tumblers', 'pagePathLevel4': ''}, 'transaction': {'currencyCode': 'USD'}, 'item': {'currencyCode': 'USD'}, 'appInfo': {'screenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'landingScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'exitScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'screenDepth': '0'}, 'exceptionInfo': {'isFatal': True}, 'product': [{'productSKU': 'GGOEGDHC074099', 'v2ProductName': 'Google 17oz Stainless Steel Sport Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '23990000', 'localProductPrice': '23990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '1'}, {'productSKU': 'GGOEGDHQ015399', 'v2ProductName': '26 oz Double Wall Insulated Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '24990000', 'localProductPrice': '24990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '2'}, {'productSKU': 'GGOEYDHJ056099', 'v2ProductName': '22 oz YouTube Bottle Infuser', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '4990000', 'localProductPrice': '4990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '3'}, {'productSKU': 'GGOEGAAX0074', 'v2ProductName': 'Google 22 oz Water Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '2990000', 'localProductPrice': '2990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '4'}], 'promotion': [], 'eCommerceAction': {'action_type': '0', 'step': '1'}, 'experiment': [], 'customVariables': [], 'customDimensions': [], 'customMetrics': [], 'type': 'PAGE', 'social': {'socialNetwork': '(not set)', 'hasSocialSourceReferral': 'No', 'socialInteractionNetworkAction': ' : '}, 'contentGroup': {'contentGroup1': '(not set)', 'contentGroup2': 'Bags', 'contentGroup3': '(not set)', 'contentGroup4': '(not set)', 'contentGroup5': '(not set)', 'previousContentGroup1': '(entrance)', 'previousContentGroup2': '(entrance)', 'previousContentGroup3': '(entrance)', 'previousContentGroup4': '(entrance)', 'previousContentGroup5': '(entrance)', 'contentGroupUniqueViews2': '1'}, 'dataSource': 'web', 'publisher_infos': []}] | Not Socially Engaged | {\"visits\": \"1\", \"hits\": \"1\", \"pageviews\": \"1\", \"bounces\": \"1\", \"newVisits\": \"1\", \"sessionQualityDim\": \"1\"} | {\"campaign\": \"(not set)\", \"source\": \"google\", \"medium\": \"organic\", \"keyword\": \"water bottle\", \"adwordsClickInfo\": {\"criteriaParameters\": \"not available in demo dataset\"}} | 1508198450 | 1 | 1508198450 |\n",
       "\n"
      ],
      "text/plain": [
       "  channelGrouping customDimensions                  date    \n",
       "1 Organic Search  [{'index': '4', 'value': 'EMEA'}] 20171016\n",
       "  device                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          \n",
       "1 {\"browser\": \"Firefox\", \"browserVersion\": \"not available in demo dataset\", \"browserSize\": \"not available in demo dataset\", \"operatingSystem\": \"Windows\", \"operatingSystemVersion\": \"not available in demo dataset\", \"isMobile\": false, \"mobileDeviceBranding\": \"not available in demo dataset\", \"mobileDeviceModel\": \"not available in demo dataset\", \"mobileInputSelector\": \"not available in demo dataset\", \"mobileDeviceInfo\": \"not available in demo dataset\", \"mobileDeviceMarketingName\": \"not available in demo dataset\", \"flashVersion\": \"not available in demo dataset\", \"language\": \"not available in demo dataset\", \"screenColors\": \"not available in demo dataset\", \"screenResolution\": \"not available in demo dataset\", \"deviceCategory\": \"desktop\"}\n",
       "  fullVisitorId\n",
       "1 3.162356e+18 \n",
       "  geoNetwork                                                                                                                                                                                                                                                                                                                                                                                                                           \n",
       "1 {\"continent\": \"Europe\", \"subContinent\": \"Western Europe\", \"country\": \"Germany\", \"region\": \"not available in demo dataset\", \"metro\": \"not available in demo dataset\", \"city\": \"not available in demo dataset\", \"cityId\": \"not available in demo dataset\", \"networkDomain\": \"(not set)\", \"latitude\": \"not available in demo dataset\", \"longitude\": \"not available in demo dataset\", \"networkLocation\": \"not available in demo dataset\"}\n",
       "  hits                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  \n",
       "1 [{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExit': True, 'referer': 'https://www.google.co.uk/search?q=water+bottle&ie=utf-8&num=100&oe=utf-8&hl=en&gl=GB&uule=w+CAIQIFISCamRx0IRO1oCEXoliDJDoPjE&glp=1&gws_rd=cr&fg=1', 'page': {'pagePath': '/google+redesign/bags/water+bottles+and+tumblers', 'hostname': 'shop.googlemerchandisestore.com', 'pageTitle': 'Water Bottles & Tumblers | Drinkware | Google Merchandise Store', 'pagePathLevel1': '/google+redesign/', 'pagePathLevel2': '/bags/', 'pagePathLevel3': '/water+bottles+and+tumblers', 'pagePathLevel4': ''}, 'transaction': {'currencyCode': 'USD'}, 'item': {'currencyCode': 'USD'}, 'appInfo': {'screenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'landingScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'exitScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'screenDepth': '0'}, 'exceptionInfo': {'isFatal': True}, 'product': [{'productSKU': 'GGOEGDHC074099', 'v2ProductName': 'Google 17oz Stainless Steel Sport Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '23990000', 'localProductPrice': '23990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '1'}, {'productSKU': 'GGOEGDHQ015399', 'v2ProductName': '26 oz Double Wall Insulated Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '24990000', 'localProductPrice': '24990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '2'}, {'productSKU': 'GGOEYDHJ056099', 'v2ProductName': '22 oz YouTube Bottle Infuser', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '4990000', 'localProductPrice': '4990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '3'}, {'productSKU': 'GGOEGAAX0074', 'v2ProductName': 'Google 22 oz Water Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '2990000', 'localProductPrice': '2990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '4'}], 'promotion': [], 'eCommerceAction': {'action_type': '0', 'step': '1'}, 'experiment': [], 'customVariables': [], 'customDimensions': [], 'customMetrics': [], 'type': 'PAGE', 'social': {'socialNetwork': '(not set)', 'hasSocialSourceReferral': 'No', 'socialInteractionNetworkAction': ' : '}, 'contentGroup': {'contentGroup1': '(not set)', 'contentGroup2': 'Bags', 'contentGroup3': '(not set)', 'contentGroup4': '(not set)', 'contentGroup5': '(not set)', 'previousContentGroup1': '(entrance)', 'previousContentGroup2': '(entrance)', 'previousContentGroup3': '(entrance)', 'previousContentGroup4': '(entrance)', 'previousContentGroup5': '(entrance)', 'contentGroupUniqueViews2': '1'}, 'dataSource': 'web', 'publisher_infos': []}]\n",
       "  socialEngagementType\n",
       "1 Not Socially Engaged\n",
       "  totals                                                                                                    \n",
       "1 {\"visits\": \"1\", \"hits\": \"1\", \"pageviews\": \"1\", \"bounces\": \"1\", \"newVisits\": \"1\", \"sessionQualityDim\": \"1\"}\n",
       "  trafficSource                                                                                                                                                             \n",
       "1 {\"campaign\": \"(not set)\", \"source\": \"google\", \"medium\": \"organic\", \"keyword\": \"water bottle\", \"adwordsClickInfo\": {\"criteriaParameters\": \"not available in demo dataset\"}}\n",
       "  visitId    visitNumber visitStartTime\n",
       "1 1508198450 1           1508198450    "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "head(data, 1)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "2a31df75",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:14:59.166671Z",
     "iopub.status.busy": "2022-11-08T20:14:59.165102Z",
     "iopub.status.idle": "2022-11-08T20:15:00.667303Z",
     "shell.execute_reply": "2022-11-08T20:15:00.664971Z"
    },
    "papermill": {
     "duration": 1.512827,
     "end_time": "2022-11-08T20:15:00.670815",
     "exception": false,
     "start_time": "2022-11-08T20:14:59.157988",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<ol>\n",
       "\t<li><dl>\n",
       "\t<dt>$browser</dt>\n",
       "\t\t<dd>'Firefox'</dd>\n",
       "\t<dt>$browserVersion</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$browserSize</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$operatingSystem</dt>\n",
       "\t\t<dd>'Windows'</dd>\n",
       "\t<dt>$operatingSystemVersion</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$isMobile</dt>\n",
       "\t\t<dd>FALSE</dd>\n",
       "\t<dt>$mobileDeviceBranding</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$mobileDeviceModel</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$mobileInputSelector</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$mobileDeviceInfo</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$mobileDeviceMarketingName</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$flashVersion</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$language</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$screenColors</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$screenResolution</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$deviceCategory</dt>\n",
       "\t\t<dd>'desktop'</dd>\n",
       "</dl>\n",
       "</li>\n",
       "</ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate}\n",
       "\\item \\begin{description}\n",
       "\\item[\\$browser] 'Firefox'\n",
       "\\item[\\$browserVersion] 'not available in demo dataset'\n",
       "\\item[\\$browserSize] 'not available in demo dataset'\n",
       "\\item[\\$operatingSystem] 'Windows'\n",
       "\\item[\\$operatingSystemVersion] 'not available in demo dataset'\n",
       "\\item[\\$isMobile] FALSE\n",
       "\\item[\\$mobileDeviceBranding] 'not available in demo dataset'\n",
       "\\item[\\$mobileDeviceModel] 'not available in demo dataset'\n",
       "\\item[\\$mobileInputSelector] 'not available in demo dataset'\n",
       "\\item[\\$mobileDeviceInfo] 'not available in demo dataset'\n",
       "\\item[\\$mobileDeviceMarketingName] 'not available in demo dataset'\n",
       "\\item[\\$flashVersion] 'not available in demo dataset'\n",
       "\\item[\\$language] 'not available in demo dataset'\n",
       "\\item[\\$screenColors] 'not available in demo dataset'\n",
       "\\item[\\$screenResolution] 'not available in demo dataset'\n",
       "\\item[\\$deviceCategory] 'desktop'\n",
       "\\end{description}\n",
       "\n",
       "\\end{enumerate}\n"
      ],
      "text/markdown": [
       "1. $browser\n",
       ":   'Firefox'\n",
       "$browserVersion\n",
       ":   'not available in demo dataset'\n",
       "$browserSize\n",
       ":   'not available in demo dataset'\n",
       "$operatingSystem\n",
       ":   'Windows'\n",
       "$operatingSystemVersion\n",
       ":   'not available in demo dataset'\n",
       "$isMobile\n",
       ":   FALSE\n",
       "$mobileDeviceBranding\n",
       ":   'not available in demo dataset'\n",
       "$mobileDeviceModel\n",
       ":   'not available in demo dataset'\n",
       "$mobileInputSelector\n",
       ":   'not available in demo dataset'\n",
       "$mobileDeviceInfo\n",
       ":   'not available in demo dataset'\n",
       "$mobileDeviceMarketingName\n",
       ":   'not available in demo dataset'\n",
       "$flashVersion\n",
       ":   'not available in demo dataset'\n",
       "$language\n",
       ":   'not available in demo dataset'\n",
       "$screenColors\n",
       ":   'not available in demo dataset'\n",
       "$screenResolution\n",
       ":   'not available in demo dataset'\n",
       "$deviceCategory\n",
       ":   'desktop'\n",
       "\n",
       "\n",
       "\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[[1]]\n",
       "[[1]]$browser\n",
       "[1] \"Firefox\"\n",
       "\n",
       "[[1]]$browserVersion\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$browserSize\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$operatingSystem\n",
       "[1] \"Windows\"\n",
       "\n",
       "[[1]]$operatingSystemVersion\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$isMobile\n",
       "[1] FALSE\n",
       "\n",
       "[[1]]$mobileDeviceBranding\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$mobileDeviceModel\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$mobileInputSelector\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$mobileDeviceInfo\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$mobileDeviceMarketingName\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$flashVersion\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$language\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$screenColors\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$screenResolution\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$deviceCategory\n",
       "[1] \"desktop\"\n",
       "\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "device_info <- lapply(data$device, fromJSON)\n",
    "device_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "cfed126d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:00.689942Z",
     "iopub.status.busy": "2022-11-08T20:15:00.688164Z",
     "iopub.status.idle": "2022-11-08T20:15:02.089410Z",
     "shell.execute_reply": "2022-11-08T20:15:02.087659Z"
    },
    "papermill": {
     "duration": 1.412428,
     "end_time": "2022-11-08T20:15:02.092023",
     "exception": false,
     "start_time": "2022-11-08T20:15:00.679595",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "browser <- c()\n",
    "os <- c()\n",
    "device_category <- c()\n",
    "\n",
    "for(i in device_info) {\n",
    "    browser <- append(browser, i$browser)\n",
    "    os <- append(os, i$operatingSystem)\n",
    "    device_category <- append(device_category, i$deviceCategory)\n",
    "}\n",
    "\n",
    "data['device_browser'] <- browser\n",
    "data['device_os'] <- os\n",
    "data['device_category'] <- device_category"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "6268bf50",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:02.106584Z",
     "iopub.status.busy": "2022-11-08T20:15:02.105126Z",
     "iopub.status.idle": "2022-11-08T20:15:03.206480Z",
     "shell.execute_reply": "2022-11-08T20:15:03.204798Z"
    },
    "papermill": {
     "duration": 1.111121,
     "end_time": "2022-11-08T20:15:03.208779",
     "exception": false,
     "start_time": "2022-11-08T20:15:02.097658",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<ol>\n",
       "\t<li><dl>\n",
       "\t<dt>$continent</dt>\n",
       "\t\t<dd>'Europe'</dd>\n",
       "\t<dt>$subContinent</dt>\n",
       "\t\t<dd>'Western Europe'</dd>\n",
       "\t<dt>$country</dt>\n",
       "\t\t<dd>'Germany'</dd>\n",
       "\t<dt>$region</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$metro</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$city</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$cityId</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$networkDomain</dt>\n",
       "\t\t<dd>'(not set)'</dd>\n",
       "\t<dt>$latitude</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$longitude</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "\t<dt>$networkLocation</dt>\n",
       "\t\t<dd>'not available in demo dataset'</dd>\n",
       "</dl>\n",
       "</li>\n",
       "</ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate}\n",
       "\\item \\begin{description}\n",
       "\\item[\\$continent] 'Europe'\n",
       "\\item[\\$subContinent] 'Western Europe'\n",
       "\\item[\\$country] 'Germany'\n",
       "\\item[\\$region] 'not available in demo dataset'\n",
       "\\item[\\$metro] 'not available in demo dataset'\n",
       "\\item[\\$city] 'not available in demo dataset'\n",
       "\\item[\\$cityId] 'not available in demo dataset'\n",
       "\\item[\\$networkDomain] '(not set)'\n",
       "\\item[\\$latitude] 'not available in demo dataset'\n",
       "\\item[\\$longitude] 'not available in demo dataset'\n",
       "\\item[\\$networkLocation] 'not available in demo dataset'\n",
       "\\end{description}\n",
       "\n",
       "\\end{enumerate}\n"
      ],
      "text/markdown": [
       "1. $continent\n",
       ":   'Europe'\n",
       "$subContinent\n",
       ":   'Western Europe'\n",
       "$country\n",
       ":   'Germany'\n",
       "$region\n",
       ":   'not available in demo dataset'\n",
       "$metro\n",
       ":   'not available in demo dataset'\n",
       "$city\n",
       ":   'not available in demo dataset'\n",
       "$cityId\n",
       ":   'not available in demo dataset'\n",
       "$networkDomain\n",
       ":   '(not set)'\n",
       "$latitude\n",
       ":   'not available in demo dataset'\n",
       "$longitude\n",
       ":   'not available in demo dataset'\n",
       "$networkLocation\n",
       ":   'not available in demo dataset'\n",
       "\n",
       "\n",
       "\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[[1]]\n",
       "[[1]]$continent\n",
       "[1] \"Europe\"\n",
       "\n",
       "[[1]]$subContinent\n",
       "[1] \"Western Europe\"\n",
       "\n",
       "[[1]]$country\n",
       "[1] \"Germany\"\n",
       "\n",
       "[[1]]$region\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$metro\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$city\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$cityId\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$networkDomain\n",
       "[1] \"(not set)\"\n",
       "\n",
       "[[1]]$latitude\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$longitude\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "[[1]]$networkLocation\n",
       "[1] \"not available in demo dataset\"\n",
       "\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "geo_network_info <- lapply(data$geoNetwork, fromJSON)\n",
    "geo_network_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "9f01e028",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:03.224651Z",
     "iopub.status.busy": "2022-11-08T20:15:03.223196Z",
     "iopub.status.idle": "2022-11-08T20:15:05.031510Z",
     "shell.execute_reply": "2022-11-08T20:15:05.029745Z"
    },
    "papermill": {
     "duration": 1.819082,
     "end_time": "2022-11-08T20:15:05.034218",
     "exception": false,
     "start_time": "2022-11-08T20:15:03.215136",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "continent <- c()\n",
    "sub_continent <- c()\n",
    "country <- c()\n",
    "network_domain <- c()\n",
    "\n",
    "for(i in geo_network_info) {\n",
    "    continent <- append(continent, i$continent)\n",
    "    sub_continent <- append(sub_continent, i$subContinent)\n",
    "    network_domain <- append(network_domain, i$networkDomain)\n",
    "    country <- append(country, i$country)\n",
    "}\n",
    "\n",
    "data['geo_info_continent'] <- continent\n",
    "data['geo_info_sub_continent'] <- sub_continent\n",
    "data['geo_info_network_domain'] <- network_domain\n",
    "data['geo_info_country'] <- country"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "b562eca9",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:05.049805Z",
     "iopub.status.busy": "2022-11-08T20:15:05.048264Z",
     "iopub.status.idle": "2022-11-08T20:15:05.809096Z",
     "shell.execute_reply": "2022-11-08T20:15:05.807471Z"
    },
    "papermill": {
     "duration": 0.771209,
     "end_time": "2022-11-08T20:15:05.811419",
     "exception": false,
     "start_time": "2022-11-08T20:15:05.040210",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<ol>\n",
       "\t<li><dl>\n",
       "\t<dt>$visits</dt>\n",
       "\t\t<dd>'1'</dd>\n",
       "\t<dt>$hits</dt>\n",
       "\t\t<dd>'1'</dd>\n",
       "\t<dt>$pageviews</dt>\n",
       "\t\t<dd>'1'</dd>\n",
       "\t<dt>$bounces</dt>\n",
       "\t\t<dd>'1'</dd>\n",
       "\t<dt>$newVisits</dt>\n",
       "\t\t<dd>'1'</dd>\n",
       "\t<dt>$sessionQualityDim</dt>\n",
       "\t\t<dd>'1'</dd>\n",
       "</dl>\n",
       "</li>\n",
       "</ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate}\n",
       "\\item \\begin{description}\n",
       "\\item[\\$visits] '1'\n",
       "\\item[\\$hits] '1'\n",
       "\\item[\\$pageviews] '1'\n",
       "\\item[\\$bounces] '1'\n",
       "\\item[\\$newVisits] '1'\n",
       "\\item[\\$sessionQualityDim] '1'\n",
       "\\end{description}\n",
       "\n",
       "\\end{enumerate}\n"
      ],
      "text/markdown": [
       "1. $visits\n",
       ":   '1'\n",
       "$hits\n",
       ":   '1'\n",
       "$pageviews\n",
       ":   '1'\n",
       "$bounces\n",
       ":   '1'\n",
       "$newVisits\n",
       ":   '1'\n",
       "$sessionQualityDim\n",
       ":   '1'\n",
       "\n",
       "\n",
       "\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[[1]]\n",
       "[[1]]$visits\n",
       "[1] \"1\"\n",
       "\n",
       "[[1]]$hits\n",
       "[1] \"1\"\n",
       "\n",
       "[[1]]$pageviews\n",
       "[1] \"1\"\n",
       "\n",
       "[[1]]$bounces\n",
       "[1] \"1\"\n",
       "\n",
       "[[1]]$newVisits\n",
       "[1] \"1\"\n",
       "\n",
       "[[1]]$sessionQualityDim\n",
       "[1] \"1\"\n",
       "\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "totals_info <- lapply(data$totals, fromJSON)\n",
    "totals_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "3a38c521",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:05.826882Z",
     "iopub.status.busy": "2022-11-08T20:15:05.825432Z",
     "iopub.status.idle": "2022-11-08T20:15:08.731081Z",
     "shell.execute_reply": "2022-11-08T20:15:08.729401Z"
    },
    "papermill": {
     "duration": 2.916098,
     "end_time": "2022-11-08T20:15:08.733568",
     "exception": false,
     "start_time": "2022-11-08T20:15:05.817470",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "visits <- c()\n",
    "hits <- c()\n",
    "page_views <- c()\n",
    "bounces <- c()\n",
    "total_transaction_revenue <- c()\n",
    "new_visits <- c()\n",
    "session_quality_dim <- c()\n",
    "transaction_revenue <- c()\n",
    "\n",
    "count <- 0\n",
    "for(i in totals_info) {\n",
    "    if(length(i$visits))\n",
    "        visits <- append(visits, i$visits)\n",
    "    else\n",
    "        visits <- append(visits, 0) \n",
    "    if(length(i$hits))\n",
    "        hits <- append(hits, i$hits)\n",
    "    else\n",
    "        hits <- append(hits, 0)\n",
    "    if(length(i$page_views))\n",
    "        page_views <- append(page_views, i$pageViews)\n",
    "    else\n",
    "        page_views <- append(page_views, 0)\n",
    "    if(length(i$bounces))\n",
    "        bounces <- append(bounces, i$bounces)\n",
    "    else\n",
    "        bounces <- append(bounces, 0)\n",
    "    if(length(i$totalTransactionRevenue))\n",
    "        total_transaction_revenue <- append(total_transaction_revenue, i$totalTransactionRevenue)\n",
    "    else\n",
    "        total_transaction_revenue <- append(total_transaction_revenue, 0)\n",
    "    if(length(i$sessionQualityDim))\n",
    "        session_quality_dim <- append(session_quality_dim, i$sessionQualityDim)\n",
    "    else\n",
    "        session_quality_dim <- append(session_quality_dim, 0)\n",
    "    if(length(i$newVisits))\n",
    "        new_visits <- append(new_visits, i$newVisits)\n",
    "    else\n",
    "        new_visits <- append(new_visits, 0)\n",
    "    if(length(i$transactionRevenue))\n",
    "        transaction_revenue <- append(transaction_revenue, i$transactionRevenue)\n",
    "    else\n",
    "        transaction_revenue <- append(transaction_revenue, 0)    \n",
    "}\n",
    "\n",
    "data['total_visits'] <- visits\n",
    "data['total_hits'] <- hits\n",
    "data['total_page_views'] <- page_views\n",
    "data['total_total_transaction_revenue'] <- total_transaction_revenue\n",
    "data['total_bounces'] <- bounces\n",
    "data['total_new_visits'] <- new_visits\n",
    "data['total_session_quality_dim'] <- session_quality_dim\n",
    "data['total_transaction_revenue'] <- transaction_revenue"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "b348d8bd",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:08.749492Z",
     "iopub.status.busy": "2022-11-08T20:15:08.748040Z",
     "iopub.status.idle": "2022-11-08T20:15:09.734643Z",
     "shell.execute_reply": "2022-11-08T20:15:09.733029Z"
    },
    "papermill": {
     "duration": 0.997044,
     "end_time": "2022-11-08T20:15:09.736953",
     "exception": false,
     "start_time": "2022-11-08T20:15:08.739909",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<ol>\n",
       "\t<li><dl>\n",
       "\t<dt>$campaign</dt>\n",
       "\t\t<dd>'(not set)'</dd>\n",
       "\t<dt>$source</dt>\n",
       "\t\t<dd>'google'</dd>\n",
       "\t<dt>$medium</dt>\n",
       "\t\t<dd>'organic'</dd>\n",
       "\t<dt>$keyword</dt>\n",
       "\t\t<dd>'water bottle'</dd>\n",
       "\t<dt>$adwordsClickInfo</dt>\n",
       "\t\t<dd><strong>$criteriaParameters</strong> = 'not available in demo dataset'</dd>\n",
       "</dl>\n",
       "</li>\n",
       "</ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate}\n",
       "\\item \\begin{description}\n",
       "\\item[\\$campaign] '(not set)'\n",
       "\\item[\\$source] 'google'\n",
       "\\item[\\$medium] 'organic'\n",
       "\\item[\\$keyword] 'water bottle'\n",
       "\\item[\\$adwordsClickInfo] \\textbf{\\$criteriaParameters} = 'not available in demo dataset'\n",
       "\\end{description}\n",
       "\n",
       "\\end{enumerate}\n"
      ],
      "text/markdown": [
       "1. $campaign\n",
       ":   '(not set)'\n",
       "$source\n",
       ":   'google'\n",
       "$medium\n",
       ":   'organic'\n",
       "$keyword\n",
       ":   'water bottle'\n",
       "$adwordsClickInfo\n",
       ":   **$criteriaParameters** = 'not available in demo dataset'\n",
       "\n",
       "\n",
       "\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[[1]]\n",
       "[[1]]$campaign\n",
       "[1] \"(not set)\"\n",
       "\n",
       "[[1]]$source\n",
       "[1] \"google\"\n",
       "\n",
       "[[1]]$medium\n",
       "[1] \"organic\"\n",
       "\n",
       "[[1]]$keyword\n",
       "[1] \"water bottle\"\n",
       "\n",
       "[[1]]$adwordsClickInfo\n",
       "[[1]]$adwordsClickInfo$criteriaParameters\n",
       "[1] \"not available in demo dataset\"\n",
       "\n",
       "\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "traffic_info <- lapply(data$trafficSource, fromJSON)\n",
    "traffic_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "921e2090",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:09.753328Z",
     "iopub.status.busy": "2022-11-08T20:15:09.751870Z",
     "iopub.status.idle": "2022-11-08T20:15:11.304205Z",
     "shell.execute_reply": "2022-11-08T20:15:11.302370Z"
    },
    "papermill": {
     "duration": 1.563068,
     "end_time": "2022-11-08T20:15:11.306729",
     "exception": false,
     "start_time": "2022-11-08T20:15:09.743661",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "campaign <- c()\n",
    "source <- c()\n",
    "medium <- c()\n",
    "keyword <- c()\n",
    "\n",
    "for(i in traffic_info) {\n",
    "    campaign <- append(campaign, i$campaign)\n",
    "    source <- append(source, i$source)\n",
    "    medium <- append(medium, i$medium)\n",
    "    if(length(i$keyword))\n",
    "        keyword <- append(keyword, i$keyword)\n",
    "    else\n",
    "        keyword <- append(keyword, '(not provided)')\n",
    "}\n",
    "\n",
    "data['traffic_campaign'] <- campaign\n",
    "data['traffic_source'] <- source\n",
    "data['traffic_medium'] <- medium\n",
    "data['traffic_keyword'] <- keyword"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "4b62ec73",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:11.323090Z",
     "iopub.status.busy": "2022-11-08T20:15:11.321516Z",
     "iopub.status.idle": "2022-11-08T20:15:11.333422Z",
     "shell.execute_reply": "2022-11-08T20:15:11.331776Z"
    },
    "papermill": {
     "duration": 0.022244,
     "end_time": "2022-11-08T20:15:11.335747",
     "exception": false,
     "start_time": "2022-11-08T20:15:11.313503",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# # gsub is used to replace characters and str_sub is used for splitting\n",
    "# hits_info <- lapply(str_sub(gsub('True', '\"True\"', gsub(\"'\", '\"', data$hits)), 2, -2), fromJSON) #gsub(\"\", \"\", data$hits)\n",
    "# hits_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "a0f09807",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:11.362234Z",
     "iopub.status.busy": "2022-11-08T20:15:11.360627Z",
     "iopub.status.idle": "2022-11-08T20:15:11.375754Z",
     "shell.execute_reply": "2022-11-08T20:15:11.373879Z"
    },
    "papermill": {
     "duration": 0.036291,
     "end_time": "2022-11-08T20:15:11.378331",
     "exception": false,
     "start_time": "2022-11-08T20:15:11.342040",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# hit_number <- c()\n",
    "# time <- c()\n",
    "# hour <- c()\n",
    "# minute <- c()\n",
    "# interaction <- c()\n",
    "# entrance <- c()\n",
    "# exit <- c()\n",
    "# referer <- c()\n",
    "# page_path <- c()\n",
    "# host_name <- c()\n",
    "# page_title <- c()\n",
    "# transaction_currency_code <- c()\n",
    "# item_currency_code <- c()\n",
    "# screen_depth <- c()\n",
    "# promotion <- c()\n",
    "# ecommerce_action <- c()\n",
    "# has_social_network_referral <- c()\n",
    "# data_source <- c()\n",
    "# publisher_info <- c()\n",
    "# product_sku <- c()\n",
    "# product_name <- c()\n",
    "# product_price <- c()\n",
    "# local_product_price <- c()\n",
    "# product_list_position <- c()\n",
    "\n",
    "\n",
    "# for(i in hits_info) {\n",
    "#     hit_number <- append(hit_number, i$hitNumber)\n",
    "#     time <- append(time, i$time)\n",
    "#     hour <- append(hour, i$hour)\n",
    "#     minute <- append(minute, i$minute)\n",
    "#     interaction <- append(interaction, i$isInteraction)\n",
    "#     entrance <- append(entrance, i$isEntrance)\n",
    "#     exit <- append(exit, i$isExit)\n",
    "#     referer <- append(referer, i$referer)\n",
    "    \n",
    "#     page_path <- append(page_path, i$page$pagePath)\n",
    "#     host_name <- append(host_name, i$page$hostName)\n",
    "#     page_title <- append(page_title, i$page$pageTitle)\n",
    "#     transaction_currency_code <- append(transaction_currency_code, i$transaction$currencyCode)\n",
    "#     item_currency_code <- append(item_currency_code, i$item$currencyCode)\n",
    "#     screen_depth <- append(screen_depth, i$appInfo$screenDepth)\n",
    "#     promotion <- append(promotion, i$promotion)\n",
    "#     ecommerce_action <- append(ecommerce_action, i$eCommerceAction$action_type)\n",
    "#     has_social_network_referral <- append(has_social_network_referral, i$social$hasSocialSourceReferral)\n",
    "#     data_source <- append(data_source, i$dataSource)\n",
    "    \n",
    "#     publisher_info <- append(publisher_info, i$publisher_infos)\n",
    "#     product_sku <- append(product_sku, c(i$product$productSKU))\n",
    "#     product_name <- append(product_name, i$product$v2ProductName)\n",
    "#     product_price <- append(product_price, i$product$productPrice)\n",
    "#     local_product_price <- append(local_product_price, i$product$localProductPrice)\n",
    "#     product_list_position <- append(product_list_position, i$product$productListPosition)\n",
    "    \n",
    "    \n",
    "# #     if(length(i$keyword))\n",
    "# #         keyword <- append(keyword, i$keyword)\n",
    "# #     else\n",
    "# #         keyword <- append(keyword, '(not provided)')\n",
    "# }\n",
    "\n",
    "# data['hits_hit_number'] <- hit_number\n",
    "# data['hits_time'] <- time\n",
    "# data['hits_hour'] <- hour\n",
    "# data['hits_minute'] <- minute\n",
    "# data['hits_interaction'] <- interaction\n",
    "# data['hits_entrance'] <- entrance\n",
    "# data['hits_exit'] <- exit\n",
    "# data['hits_referer'] <- referer\n",
    "# data['hits_page_path'] <- page_path\n",
    "# data['hits_host_name'] <- host_name\n",
    "# data['hits_page_title'] <- page_title\n",
    "# data['hits_transaction_currency_code'] <- transaction_currency_code\n",
    "# data['hits_item_currency_code'] <- item_currency_code\n",
    "# data['hits_screen_depth'] <- screen_depth\n",
    "# data['hits_promotion'] <- promotion\n",
    "# data['hits_ecommerce_action'] <- ecommerce_action\n",
    "# data['hits_has_social_network_referral'] <- has_social_network_referral\n",
    "# data['hits_data_source'] <- data_source\n",
    "# data['hits_publisher_info'] <- publisher_info\n",
    "# data['hits_product_sku'] <- product_sku\n",
    "# data['hits_product_name'] <- product_name\n",
    "# data['hits_product_price'] <- product_price\n",
    "# data['hits_local_product_price'] <- local_product_price\n",
    "# data['hits_product_list_position'] <- product_list_position"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "id": "c811b10e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:11.395178Z",
     "iopub.status.busy": "2022-11-08T20:15:11.393491Z",
     "iopub.status.idle": "2022-11-08T20:15:12.619612Z",
     "shell.execute_reply": "2022-11-08T20:15:12.617826Z"
    },
    "papermill": {
     "duration": 1.237291,
     "end_time": "2022-11-08T20:15:12.622076",
     "exception": false,
     "start_time": "2022-11-08T20:15:11.384785",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<ol>\n",
       "\t<li><table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 2</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>index</th><th scope=col>value</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>4</td><td>EMEA</td></tr>\n",
       "</tbody>\n",
       "</table>\n",
       "</li>\n",
       "</ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate}\n",
       "\\item A data.frame: 1 × 2\n",
       "\\begin{tabular}{r|ll}\n",
       "  & index & value\\\\\n",
       "  & <chr> & <chr>\\\\\n",
       "\\hline\n",
       "\t1 & 4 & EMEA\\\\\n",
       "\\end{tabular}\n",
       "\n",
       "\\end{enumerate}\n"
      ],
      "text/markdown": [
       "1. \n",
       "A data.frame: 1 × 2\n",
       "\n",
       "| <!--/--> | index &lt;chr&gt; | value &lt;chr&gt; |\n",
       "|---|---|---|\n",
       "| 1 | 4 | EMEA |\n",
       "\n",
       "\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[[1]]\n",
       "  index value\n",
       "1     4  EMEA\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "# # gsub is used to replace characters and str_sub is used for splitting\n",
    "custom_info <- lapply(str_sub(gsub(\"'\", '\"', data$customDimensions, 2, -2)), fromJSON) #gsub(\"\", \"\", data$hits)\n",
    "custom_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "id": "4016fc45",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:12.645676Z",
     "iopub.status.busy": "2022-11-08T20:15:12.637103Z",
     "iopub.status.idle": "2022-11-08T20:15:13.484059Z",
     "shell.execute_reply": "2022-11-08T20:15:13.482169Z"
    },
    "papermill": {
     "duration": 0.857972,
     "end_time": "2022-11-08T20:15:13.486494",
     "exception": false,
     "start_time": "2022-11-08T20:15:12.628522",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "index <- c()\n",
    "value <- c()\n",
    "\n",
    "for(i in custom_info) {\n",
    "    if(length(i$index))\n",
    "        index <- append(index, i$index)\n",
    "    else\n",
    "        index <- append(index, 0)\n",
    "    if(length(i$value))\n",
    "        value <- append(value, i$value)    \n",
    "    else\n",
    "        value <- append(value, 0)\n",
    "}\n",
    "\n",
    "data['custom_index'] <- index\n",
    "data['custom_value'] <- value"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "id": "83d0be43",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-08T20:15:13.503445Z",
     "iopub.status.busy": "2022-11-08T20:15:13.501886Z",
     "iopub.status.idle": "2022-11-08T20:15:13.572234Z",
     "shell.execute_reply": "2022-11-08T20:15:13.570489Z"
    },
    "papermill": {
     "duration": 0.081343,
     "end_time": "2022-11-08T20:15:13.574550",
     "exception": false,
     "start_time": "2022-11-08T20:15:13.493207",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Removing all columns from which data has been extracted\n",
    "data <- data %>% select(-c('customDimensions', 'device', 'geoNetwork', 'totals', 'trafficSource'))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "895bfb4e",
   "metadata": {
    "papermill": {
     "duration": 0.006642,
     "end_time": "2022-11-08T20:15:13.587900",
     "exception": false,
     "start_time": "2022-11-08T20:15:13.581258",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 23.749499,
   "end_time": "2022-11-08T20:15:13.715023",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-11-08T20:14:49.965524",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
