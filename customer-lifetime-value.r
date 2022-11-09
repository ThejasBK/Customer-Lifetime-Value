{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "808c5194",
   "metadata": {
    "papermill": {
     "duration": 0.009237,
     "end_time": "2022-11-09T17:14:55.045579",
     "exception": false,
     "start_time": "2022-11-09T17:14:55.036342",
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
   "id": "9945da72",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:14:55.063869Z",
     "iopub.status.busy": "2022-11-09T17:14:55.061938Z",
     "iopub.status.idle": "2022-11-09T17:14:55.273041Z",
     "shell.execute_reply": "2022-11-09T17:14:55.271201Z"
    },
    "papermill": {
     "duration": 0.222697,
     "end_time": "2022-11-09T17:14:55.275457",
     "exception": false,
     "start_time": "2022-11-09T17:14:55.052760",
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
   "id": "78506245",
   "metadata": {
    "_cell_guid": "b1076dfc-b9ad-4769-8c92-a6c4dae69d19",
    "_uuid": "8f2839f25d086af736a60e9eeb907d3b93b6e0e5",
    "execution": {
     "iopub.execute_input": "2022-11-09T17:14:55.322529Z",
     "iopub.status.busy": "2022-11-09T17:14:55.292202Z",
     "iopub.status.idle": "2022-11-09T17:15:15.544229Z",
     "shell.execute_reply": "2022-11-09T17:15:15.542426Z"
    },
    "papermill": {
     "duration": 20.264964,
     "end_time": "2022-11-09T17:15:15.547917",
     "exception": false,
     "start_time": "2022-11-09T17:14:55.282953",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "data <- read.csv('../input/ga-customer-revenue-prediction/train_v2.csv', nrows = 50000)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "3c82fd63",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:15:15.566510Z",
     "iopub.status.busy": "2022-11-09T17:15:15.565029Z",
     "iopub.status.idle": "2022-11-09T17:15:15.587230Z",
     "shell.execute_reply": "2022-11-09T17:15:15.584956Z"
    },
    "papermill": {
     "duration": 0.034543,
     "end_time": "2022-11-09T17:15:15.590249",
     "exception": false,
     "start_time": "2022-11-09T17:15:15.555706",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "50000"
      ],
      "text/latex": [
       "50000"
      ],
      "text/markdown": [
       "50000"
      ],
      "text/plain": [
       "[1] 50000"
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
   "id": "f428e41d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:15:15.609745Z",
     "iopub.status.busy": "2022-11-09T17:15:15.608160Z",
     "iopub.status.idle": "2022-11-09T17:15:15.647384Z",
     "shell.execute_reply": "2022-11-09T17:15:15.644624Z"
    },
    "papermill": {
     "duration": 0.052554,
     "end_time": "2022-11-09T17:15:15.650424",
     "exception": false,
     "start_time": "2022-11-09T17:15:15.597870",
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
   "id": "fe5d57d3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:15:15.671104Z",
     "iopub.status.busy": "2022-11-09T17:15:15.669514Z",
     "iopub.status.idle": "2022-11-09T17:15:23.315371Z",
     "shell.execute_reply": "2022-11-09T17:15:23.313024Z"
    },
    "papermill": {
     "duration": 7.659354,
     "end_time": "2022-11-09T17:15:23.318766",
     "exception": false,
     "start_time": "2022-11-09T17:15:15.659412",
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
   "id": "a44944f6",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:15:23.338756Z",
     "iopub.status.busy": "2022-11-09T17:15:23.337302Z",
     "iopub.status.idle": "2022-11-09T17:15:49.204549Z",
     "shell.execute_reply": "2022-11-09T17:15:49.202692Z"
    },
    "papermill": {
     "duration": 25.880861,
     "end_time": "2022-11-09T17:15:49.208014",
     "exception": false,
     "start_time": "2022-11-09T17:15:23.327153",
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
   "id": "4c3698db",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:15:49.236156Z",
     "iopub.status.busy": "2022-11-09T17:15:49.233485Z",
     "iopub.status.idle": "2022-11-09T17:15:55.292601Z",
     "shell.execute_reply": "2022-11-09T17:15:55.290833Z"
    },
    "papermill": {
     "duration": 6.075624,
     "end_time": "2022-11-09T17:15:55.295061",
     "exception": false,
     "start_time": "2022-11-09T17:15:49.219437",
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
   "id": "79b1a55c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:15:55.316018Z",
     "iopub.status.busy": "2022-11-09T17:15:55.314484Z",
     "iopub.status.idle": "2022-11-09T17:16:34.312619Z",
     "shell.execute_reply": "2022-11-09T17:16:34.310867Z"
    },
    "papermill": {
     "duration": 39.01135,
     "end_time": "2022-11-09T17:16:34.315164",
     "exception": false,
     "start_time": "2022-11-09T17:15:55.303814",
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
   "id": "6343e413",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:16:34.341562Z",
     "iopub.status.busy": "2022-11-09T17:16:34.340083Z",
     "iopub.status.idle": "2022-11-09T17:16:37.957188Z",
     "shell.execute_reply": "2022-11-09T17:16:37.955456Z"
    },
    "papermill": {
     "duration": 3.635668,
     "end_time": "2022-11-09T17:16:37.959667",
     "exception": false,
     "start_time": "2022-11-09T17:16:34.323999",
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
   "id": "2a0218fd",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:16:37.982805Z",
     "iopub.status.busy": "2022-11-09T17:16:37.981270Z",
     "iopub.status.idle": "2022-11-09T17:17:44.021259Z",
     "shell.execute_reply": "2022-11-09T17:17:44.019492Z"
    },
    "papermill": {
     "duration": 66.054394,
     "end_time": "2022-11-09T17:17:44.023596",
     "exception": false,
     "start_time": "2022-11-09T17:16:37.969202",
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
   "id": "54eec404",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:17:44.044780Z",
     "iopub.status.busy": "2022-11-09T17:17:44.043306Z",
     "iopub.status.idle": "2022-11-09T17:17:49.129154Z",
     "shell.execute_reply": "2022-11-09T17:17:49.127468Z"
    },
    "papermill": {
     "duration": 5.099284,
     "end_time": "2022-11-09T17:17:49.131770",
     "exception": false,
     "start_time": "2022-11-09T17:17:44.032486",
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
   "id": "d739b086",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:17:49.154736Z",
     "iopub.status.busy": "2022-11-09T17:17:49.153246Z",
     "iopub.status.idle": "2022-11-09T17:18:22.895432Z",
     "shell.execute_reply": "2022-11-09T17:18:22.893704Z"
    },
    "papermill": {
     "duration": 33.755802,
     "end_time": "2022-11-09T17:18:22.897879",
     "exception": false,
     "start_time": "2022-11-09T17:17:49.142077",
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
   "id": "e2b7ac76",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:22.919711Z",
     "iopub.status.busy": "2022-11-09T17:18:22.918275Z",
     "iopub.status.idle": "2022-11-09T17:18:22.929964Z",
     "shell.execute_reply": "2022-11-09T17:18:22.928348Z"
    },
    "papermill": {
     "duration": 0.025351,
     "end_time": "2022-11-09T17:18:22.932362",
     "exception": false,
     "start_time": "2022-11-09T17:18:22.907011",
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
   "id": "21c7047b",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:22.954199Z",
     "iopub.status.busy": "2022-11-09T17:18:22.952713Z",
     "iopub.status.idle": "2022-11-09T17:18:22.966825Z",
     "shell.execute_reply": "2022-11-09T17:18:22.965144Z"
    },
    "papermill": {
     "duration": 0.027817,
     "end_time": "2022-11-09T17:18:22.969216",
     "exception": false,
     "start_time": "2022-11-09T17:18:22.941399",
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
   "id": "f480c67d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:22.990535Z",
     "iopub.status.busy": "2022-11-09T17:18:22.989135Z",
     "iopub.status.idle": "2022-11-09T17:18:28.197980Z",
     "shell.execute_reply": "2022-11-09T17:18:28.195717Z"
    },
    "papermill": {
     "duration": 5.223039,
     "end_time": "2022-11-09T17:18:28.201290",
     "exception": false,
     "start_time": "2022-11-09T17:18:22.978251",
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
   "id": "61fd6ff5",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:28.222888Z",
     "iopub.status.busy": "2022-11-09T17:18:28.221438Z",
     "iopub.status.idle": "2022-11-09T17:18:45.940466Z",
     "shell.execute_reply": "2022-11-09T17:18:45.938653Z"
    },
    "papermill": {
     "duration": 17.732388,
     "end_time": "2022-11-09T17:18:45.942886",
     "exception": false,
     "start_time": "2022-11-09T17:18:28.210498",
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
   "id": "101c4820",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:45.965572Z",
     "iopub.status.busy": "2022-11-09T17:18:45.963882Z",
     "iopub.status.idle": "2022-11-09T17:18:46.034509Z",
     "shell.execute_reply": "2022-11-09T17:18:46.032727Z"
    },
    "papermill": {
     "duration": 0.085901,
     "end_time": "2022-11-09T17:18:46.038137",
     "exception": false,
     "start_time": "2022-11-09T17:18:45.952236",
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
   "execution_count": 18,
   "id": "d89dd6f4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.060218Z",
     "iopub.status.busy": "2022-11-09T17:18:46.058770Z",
     "iopub.status.idle": "2022-11-09T17:18:46.092548Z",
     "shell.execute_reply": "2022-11-09T17:18:46.090936Z"
    },
    "papermill": {
     "duration": 0.047433,
     "end_time": "2022-11-09T17:18:46.094819",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.047386",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 29</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>channelGrouping</th><th scope=col>date</th><th scope=col>fullVisitorId</th><th scope=col>hits</th><th scope=col>socialEngagementType</th><th scope=col>visitId</th><th scope=col>visitNumber</th><th scope=col>visitStartTime</th><th scope=col>device_browser</th><th scope=col>device_os</th><th scope=col>⋯</th><th scope=col>total_bounces</th><th scope=col>total_new_visits</th><th scope=col>total_session_quality_dim</th><th scope=col>total_transaction_revenue</th><th scope=col>traffic_campaign</th><th scope=col>traffic_source</th><th scope=col>traffic_medium</th><th scope=col>traffic_keyword</th><th scope=col>custom_index</th><th scope=col>custom_value</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>⋯</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>Organic Search</td><td>20171016</td><td>3.162356e+18</td><td>[{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExit': True, 'referer': 'https://www.google.co.uk/search?q=water+bottle&amp;ie=utf-8&amp;num=100&amp;oe=utf-8&amp;hl=en&amp;gl=GB&amp;uule=w+CAIQIFISCamRx0IRO1oCEXoliDJDoPjE&amp;glp=1&amp;gws_rd=cr&amp;fg=1', 'page': {'pagePath': '/google+redesign/bags/water+bottles+and+tumblers', 'hostname': 'shop.googlemerchandisestore.com', 'pageTitle': 'Water Bottles &amp; Tumblers | Drinkware | Google Merchandise Store', 'pagePathLevel1': '/google+redesign/', 'pagePathLevel2': '/bags/', 'pagePathLevel3': '/water+bottles+and+tumblers', 'pagePathLevel4': ''}, 'transaction': {'currencyCode': 'USD'}, 'item': {'currencyCode': 'USD'}, 'appInfo': {'screenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'landingScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'exitScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'screenDepth': '0'}, 'exceptionInfo': {'isFatal': True}, 'product': [{'productSKU': 'GGOEGDHC074099', 'v2ProductName': 'Google 17oz Stainless Steel Sport Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '23990000', 'localProductPrice': '23990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '1'}, {'productSKU': 'GGOEGDHQ015399', 'v2ProductName': '26 oz Double Wall Insulated Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '24990000', 'localProductPrice': '24990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '2'}, {'productSKU': 'GGOEYDHJ056099', 'v2ProductName': '22 oz YouTube Bottle Infuser', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '4990000', 'localProductPrice': '4990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '3'}, {'productSKU': 'GGOEGAAX0074', 'v2ProductName': 'Google 22 oz Water Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '2990000', 'localProductPrice': '2990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '4'}], 'promotion': [], 'eCommerceAction': {'action_type': '0', 'step': '1'}, 'experiment': [], 'customVariables': [], 'customDimensions': [], 'customMetrics': [], 'type': 'PAGE', 'social': {'socialNetwork': '(not set)', 'hasSocialSourceReferral': 'No', 'socialInteractionNetworkAction': ' : '}, 'contentGroup': {'contentGroup1': '(not set)', 'contentGroup2': 'Bags', 'contentGroup3': '(not set)', 'contentGroup4': '(not set)', 'contentGroup5': '(not set)', 'previousContentGroup1': '(entrance)', 'previousContentGroup2': '(entrance)', 'previousContentGroup3': '(entrance)', 'previousContentGroup4': '(entrance)', 'previousContentGroup5': '(entrance)', 'contentGroupUniqueViews2': '1'}, 'dataSource': 'web', 'publisher_infos': []}]</td><td>Not Socially Engaged</td><td>1508198450</td><td>1</td><td>1508198450</td><td>Firefox</td><td>Windows</td><td>⋯</td><td>1</td><td>1</td><td>1</td><td>0</td><td>(not set)</td><td>google</td><td>organic</td><td>water bottle</td><td>4</td><td>EMEA</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 29\n",
       "\\begin{tabular}{r|lllllllllllllllllllll}\n",
       "  & channelGrouping & date & fullVisitorId & hits & socialEngagementType & visitId & visitNumber & visitStartTime & device\\_browser & device\\_os & ⋯ & total\\_bounces & total\\_new\\_visits & total\\_session\\_quality\\_dim & total\\_transaction\\_revenue & traffic\\_campaign & traffic\\_source & traffic\\_medium & traffic\\_keyword & custom\\_index & custom\\_value\\\\\n",
       "  & <chr> & <int> & <dbl> & <chr> & <chr> & <int> & <int> & <int> & <chr> & <chr> & ⋯ & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr>\\\\\n",
       "\\hline\n",
       "\t1 & Organic Search & 20171016 & 3.162356e+18 & {[}\\{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExit': True, 'referer': 'https://www.google.co.uk/search?q=water+bottle\\&ie=utf-8\\&num=100\\&oe=utf-8\\&hl=en\\&gl=GB\\&uule=w+CAIQIFISCamRx0IRO1oCEXoliDJDoPjE\\&glp=1\\&gws\\_rd=cr\\&fg=1', 'page': \\{'pagePath': '/google+redesign/bags/water+bottles+and+tumblers', 'hostname': 'shop.googlemerchandisestore.com', 'pageTitle': 'Water Bottles \\& Tumblers \\textbar{} Drinkware \\textbar{} Google Merchandise Store', 'pagePathLevel1': '/google+redesign/', 'pagePathLevel2': '/bags/', 'pagePathLevel3': '/water+bottles+and+tumblers', 'pagePathLevel4': ''\\}, 'transaction': \\{'currencyCode': 'USD'\\}, 'item': \\{'currencyCode': 'USD'\\}, 'appInfo': \\{'screenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'landingScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'exitScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'screenDepth': '0'\\}, 'exceptionInfo': \\{'isFatal': True\\}, 'product': {[}\\{'productSKU': 'GGOEGDHC074099', 'v2ProductName': 'Google 17oz Stainless Steel Sport Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '23990000', 'localProductPrice': '23990000', 'isImpression': True, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'productListName': 'Category', 'productListPosition': '1'\\}, \\{'productSKU': 'GGOEGDHQ015399', 'v2ProductName': '26 oz Double Wall Insulated Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '24990000', 'localProductPrice': '24990000', 'isImpression': True, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'productListName': 'Category', 'productListPosition': '2'\\}, \\{'productSKU': 'GGOEYDHJ056099', 'v2ProductName': '22 oz YouTube Bottle Infuser', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '4990000', 'localProductPrice': '4990000', 'isImpression': True, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'productListName': 'Category', 'productListPosition': '3'\\}, \\{'productSKU': 'GGOEGAAX0074', 'v2ProductName': 'Google 22 oz Water Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '2990000', 'localProductPrice': '2990000', 'isImpression': True, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'productListName': 'Category', 'productListPosition': '4'\\}{]}, 'promotion': {[}{]}, 'eCommerceAction': \\{'action\\_type': '0', 'step': '1'\\}, 'experiment': {[}{]}, 'customVariables': {[}{]}, 'customDimensions': {[}{]}, 'customMetrics': {[}{]}, 'type': 'PAGE', 'social': \\{'socialNetwork': '(not set)', 'hasSocialSourceReferral': 'No', 'socialInteractionNetworkAction': ' : '\\}, 'contentGroup': \\{'contentGroup1': '(not set)', 'contentGroup2': 'Bags', 'contentGroup3': '(not set)', 'contentGroup4': '(not set)', 'contentGroup5': '(not set)', 'previousContentGroup1': '(entrance)', 'previousContentGroup2': '(entrance)', 'previousContentGroup3': '(entrance)', 'previousContentGroup4': '(entrance)', 'previousContentGroup5': '(entrance)', 'contentGroupUniqueViews2': '1'\\}, 'dataSource': 'web', 'publisher\\_infos': {[}{]}\\}{]} & Not Socially Engaged & 1508198450 & 1 & 1508198450 & Firefox & Windows & ⋯ & 1 & 1 & 1 & 0 & (not set) & google & organic & water bottle & 4 & EMEA\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 29\n",
       "\n",
       "| <!--/--> | channelGrouping &lt;chr&gt; | date &lt;int&gt; | fullVisitorId &lt;dbl&gt; | hits &lt;chr&gt; | socialEngagementType &lt;chr&gt; | visitId &lt;int&gt; | visitNumber &lt;int&gt; | visitStartTime &lt;int&gt; | device_browser &lt;chr&gt; | device_os &lt;chr&gt; | ⋯ ⋯ | total_bounces &lt;chr&gt; | total_new_visits &lt;chr&gt; | total_session_quality_dim &lt;chr&gt; | total_transaction_revenue &lt;chr&gt; | traffic_campaign &lt;chr&gt; | traffic_source &lt;chr&gt; | traffic_medium &lt;chr&gt; | traffic_keyword &lt;chr&gt; | custom_index &lt;chr&gt; | custom_value &lt;chr&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 1 | Organic Search | 20171016 | 3.162356e+18 | [{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExit': True, 'referer': 'https://www.google.co.uk/search?q=water+bottle&amp;ie=utf-8&amp;num=100&amp;oe=utf-8&amp;hl=en&amp;gl=GB&amp;uule=w+CAIQIFISCamRx0IRO1oCEXoliDJDoPjE&amp;glp=1&amp;gws_rd=cr&amp;fg=1', 'page': {'pagePath': '/google+redesign/bags/water+bottles+and+tumblers', 'hostname': 'shop.googlemerchandisestore.com', 'pageTitle': 'Water Bottles &amp; Tumblers | Drinkware | Google Merchandise Store', 'pagePathLevel1': '/google+redesign/', 'pagePathLevel2': '/bags/', 'pagePathLevel3': '/water+bottles+and+tumblers', 'pagePathLevel4': ''}, 'transaction': {'currencyCode': 'USD'}, 'item': {'currencyCode': 'USD'}, 'appInfo': {'screenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'landingScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'exitScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'screenDepth': '0'}, 'exceptionInfo': {'isFatal': True}, 'product': [{'productSKU': 'GGOEGDHC074099', 'v2ProductName': 'Google 17oz Stainless Steel Sport Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '23990000', 'localProductPrice': '23990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '1'}, {'productSKU': 'GGOEGDHQ015399', 'v2ProductName': '26 oz Double Wall Insulated Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '24990000', 'localProductPrice': '24990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '2'}, {'productSKU': 'GGOEYDHJ056099', 'v2ProductName': '22 oz YouTube Bottle Infuser', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '4990000', 'localProductPrice': '4990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '3'}, {'productSKU': 'GGOEGAAX0074', 'v2ProductName': 'Google 22 oz Water Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '2990000', 'localProductPrice': '2990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '4'}], 'promotion': [], 'eCommerceAction': {'action_type': '0', 'step': '1'}, 'experiment': [], 'customVariables': [], 'customDimensions': [], 'customMetrics': [], 'type': 'PAGE', 'social': {'socialNetwork': '(not set)', 'hasSocialSourceReferral': 'No', 'socialInteractionNetworkAction': ' : '}, 'contentGroup': {'contentGroup1': '(not set)', 'contentGroup2': 'Bags', 'contentGroup3': '(not set)', 'contentGroup4': '(not set)', 'contentGroup5': '(not set)', 'previousContentGroup1': '(entrance)', 'previousContentGroup2': '(entrance)', 'previousContentGroup3': '(entrance)', 'previousContentGroup4': '(entrance)', 'previousContentGroup5': '(entrance)', 'contentGroupUniqueViews2': '1'}, 'dataSource': 'web', 'publisher_infos': []}] | Not Socially Engaged | 1508198450 | 1 | 1508198450 | Firefox | Windows | ⋯ | 1 | 1 | 1 | 0 | (not set) | google | organic | water bottle | 4 | EMEA |\n",
       "\n"
      ],
      "text/plain": [
       "  channelGrouping date     fullVisitorId\n",
       "1 Organic Search  20171016 3.162356e+18 \n",
       "  hits                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  \n",
       "1 [{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExit': True, 'referer': 'https://www.google.co.uk/search?q=water+bottle&ie=utf-8&num=100&oe=utf-8&hl=en&gl=GB&uule=w+CAIQIFISCamRx0IRO1oCEXoliDJDoPjE&glp=1&gws_rd=cr&fg=1', 'page': {'pagePath': '/google+redesign/bags/water+bottles+and+tumblers', 'hostname': 'shop.googlemerchandisestore.com', 'pageTitle': 'Water Bottles & Tumblers | Drinkware | Google Merchandise Store', 'pagePathLevel1': '/google+redesign/', 'pagePathLevel2': '/bags/', 'pagePathLevel3': '/water+bottles+and+tumblers', 'pagePathLevel4': ''}, 'transaction': {'currencyCode': 'USD'}, 'item': {'currencyCode': 'USD'}, 'appInfo': {'screenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'landingScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'exitScreenName': 'shop.googlemerchandisestore.com/google+redesign/bags/water+bottles+and+tumblers', 'screenDepth': '0'}, 'exceptionInfo': {'isFatal': True}, 'product': [{'productSKU': 'GGOEGDHC074099', 'v2ProductName': 'Google 17oz Stainless Steel Sport Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '23990000', 'localProductPrice': '23990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '1'}, {'productSKU': 'GGOEGDHQ015399', 'v2ProductName': '26 oz Double Wall Insulated Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '24990000', 'localProductPrice': '24990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '2'}, {'productSKU': 'GGOEYDHJ056099', 'v2ProductName': '22 oz YouTube Bottle Infuser', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '4990000', 'localProductPrice': '4990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '3'}, {'productSKU': 'GGOEGAAX0074', 'v2ProductName': 'Google 22 oz Water Bottle', 'v2ProductCategory': 'Home/Drinkware/Water Bottles and Tumblers/', 'productVariant': '(not set)', 'productBrand': '(not set)', 'productPrice': '2990000', 'localProductPrice': '2990000', 'isImpression': True, 'customDimensions': [], 'customMetrics': [], 'productListName': 'Category', 'productListPosition': '4'}], 'promotion': [], 'eCommerceAction': {'action_type': '0', 'step': '1'}, 'experiment': [], 'customVariables': [], 'customDimensions': [], 'customMetrics': [], 'type': 'PAGE', 'social': {'socialNetwork': '(not set)', 'hasSocialSourceReferral': 'No', 'socialInteractionNetworkAction': ' : '}, 'contentGroup': {'contentGroup1': '(not set)', 'contentGroup2': 'Bags', 'contentGroup3': '(not set)', 'contentGroup4': '(not set)', 'contentGroup5': '(not set)', 'previousContentGroup1': '(entrance)', 'previousContentGroup2': '(entrance)', 'previousContentGroup3': '(entrance)', 'previousContentGroup4': '(entrance)', 'previousContentGroup5': '(entrance)', 'contentGroupUniqueViews2': '1'}, 'dataSource': 'web', 'publisher_infos': []}]\n",
       "  socialEngagementType visitId    visitNumber visitStartTime device_browser\n",
       "1 Not Socially Engaged 1508198450 1           1508198450     Firefox       \n",
       "  device_os ⋯ total_bounces total_new_visits total_session_quality_dim\n",
       "1 Windows   ⋯ 1             1                1                        \n",
       "  total_transaction_revenue traffic_campaign traffic_source traffic_medium\n",
       "1 0                         (not set)        google         organic       \n",
       "  traffic_keyword custom_index custom_value\n",
       "1 water bottle    4            EMEA        "
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
   "execution_count": 19,
   "id": "3b526e49",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.118192Z",
     "iopub.status.busy": "2022-11-09T17:18:46.116713Z",
     "iopub.status.idle": "2022-11-09T17:18:46.176070Z",
     "shell.execute_reply": "2022-11-09T17:18:46.173726Z"
    },
    "papermill": {
     "duration": 0.073541,
     "end_time": "2022-11-09T17:18:46.178641",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.105100",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "'data.frame':\t50000 obs. of  29 variables:\n",
      " $ channelGrouping                : chr  \"Organic Search\" \"Referral\" \"Direct\" \"Organic Search\" ...\n",
      " $ date                           : int  20171016 20171016 20171016 20171016 20171016 20171016 20171016 20171016 20171016 20171016 ...\n",
      " $ fullVisitorId                  : num  3.16e+18 8.93e+18 7.99e+18 9.08e+18 6.96e+18 ...\n",
      " $ hits                           : chr  \"[{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '0', 'isInteraction': True, 'isEntrance': True, 'isExi\"| __truncated__ \"[{'hitNumber': '1', 'time': '0', 'hour': '10', 'minute': '51', 'isInteraction': True, 'isEntrance': True, 'refe\"| __truncated__ \"[{'hitNumber': '1', 'time': '0', 'hour': '17', 'minute': '53', 'isInteraction': True, 'isEntrance': True, 'refe\"| __truncated__ \"[{'hitNumber': '1', 'time': '0', 'hour': '9', 'minute': '4', 'isInteraction': True, 'isEntrance': True, 'refere\"| __truncated__ ...\n",
      " $ socialEngagementType           : chr  \"Not Socially Engaged\" \"Not Socially Engaged\" \"Not Socially Engaged\" \"Not Socially Engaged\" ...\n",
      " $ visitId                        : int  1508198450 1508176307 1508201613 1508169851 1508190552 1508196701 1508152478 1508206208 1508207516 1508165159 ...\n",
      " $ visitNumber                    : int  1 6 1 1 1 1 1 1 1 2 ...\n",
      " $ visitStartTime                 : int  1508198450 1508176307 1508201613 1508169851 1508190552 1508196701 1508152478 1508206208 1508207516 1508165159 ...\n",
      " $ device_browser                 : chr  \"Firefox\" \"Chrome\" \"Chrome\" \"Chrome\" ...\n",
      " $ device_os                      : chr  \"Windows\" \"Chrome OS\" \"Android\" \"Windows\" ...\n",
      " $ device_category                : chr  \"desktop\" \"desktop\" \"mobile\" \"desktop\" ...\n",
      " $ geo_info_continent             : chr  \"Europe\" \"Americas\" \"Americas\" \"Asia\" ...\n",
      " $ geo_info_sub_continent         : chr  \"Western Europe\" \"Northern America\" \"Northern America\" \"Western Asia\" ...\n",
      " $ geo_info_network_domain        : chr  \"(not set)\" \"(not set)\" \"windjammercable.net\" \"unknown.unknown\" ...\n",
      " $ geo_info_country               : chr  \"Germany\" \"United States\" \"United States\" \"Turkey\" ...\n",
      " $ total_visits                   : chr  \"1\" \"1\" \"1\" \"1\" ...\n",
      " $ total_hits                     : chr  \"1\" \"2\" \"2\" \"2\" ...\n",
      " $ total_page_views               : num  0 0 0 0 0 0 0 0 0 0 ...\n",
      " $ total_total_transaction_revenue: chr  \"0\" \"0\" \"0\" \"0\" ...\n",
      " $ total_bounces                  : chr  \"1\" \"0\" \"0\" \"0\" ...\n",
      " $ total_new_visits               : chr  \"1\" \"0\" \"1\" \"1\" ...\n",
      " $ total_session_quality_dim      : chr  \"1\" \"2\" \"1\" \"1\" ...\n",
      " $ total_transaction_revenue      : chr  \"0\" \"0\" \"0\" \"0\" ...\n",
      " $ traffic_campaign               : chr  \"(not set)\" \"(not set)\" \"(not set)\" \"(not set)\" ...\n",
      " $ traffic_source                 : chr  \"google\" \"sites.google.com\" \"(direct)\" \"google\" ...\n",
      " $ traffic_medium                 : chr  \"organic\" \"referral\" \"(none)\" \"organic\" ...\n",
      " $ traffic_keyword                : chr  \"water bottle\" \"(not provided)\" \"(not provided)\" \"(not provided)\" ...\n",
      " $ custom_index                   : chr  \"4\" \"4\" \"4\" \"4\" ...\n",
      " $ custom_value                   : chr  \"EMEA\" \"North America\" \"North America\" \"EMEA\" ...\n"
     ]
    }
   ],
   "source": [
    "str(data)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 20,
   "id": "7e8967dd",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.203408Z",
     "iopub.status.busy": "2022-11-09T17:18:46.201943Z",
     "iopub.status.idle": "2022-11-09T17:18:46.279460Z",
     "shell.execute_reply": "2022-11-09T17:18:46.277671Z"
    },
    "papermill": {
     "duration": 0.092078,
     "end_time": "2022-11-09T17:18:46.281797",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.189719",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Converting the data types of some columns in the dataframe\n",
    "data$total_visits <- as.numeric(data$total_visits)\n",
    "data$total_hits <- as.numeric(data$total_hits)\n",
    "data$total_total_transaction_revenue <- as.numeric(data$total_total_transaction_revenue)\n",
    "data$total_bounces <- as.numeric(data$total_bounces)\n",
    "data$total_new_visits <- as.numeric(data$total_new_visits)\n",
    "data$total_session_quality_dim <- as.numeric(data$total_session_quality_dim)\n",
    "data$total_transaction_revenue <- as.numeric(data$total_transaction_revenue)\n",
    "data$custom_index <- as.numeric(data$custom_index)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 21,
   "id": "5755001b",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.305822Z",
     "iopub.status.busy": "2022-11-09T17:18:46.304406Z",
     "iopub.status.idle": "2022-11-09T17:18:46.327719Z",
     "shell.execute_reply": "2022-11-09T17:18:46.325914Z"
    },
    "papermill": {
     "duration": 0.037638,
     "end_time": "2022-11-09T17:18:46.330129",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.292491",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Organic Search 21270\"\n",
      "[1] \"Referral 6179\"\n",
      "[1] \"Direct 7305\"\n",
      "[1] \"Paid Search 1279\"\n",
      "[1] \"Display 940\"\n",
      "[1] \"Affiliates 943\"\n",
      "[1] \"Social 12083\"\n",
      "[1] \"(Other) 1\"\n"
     ]
    }
   ],
   "source": [
    "for(i in unique(data$channelGrouping)){\n",
    "    print(paste(i, sum(data$channelGrouping == i)))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 22,
   "id": "6f22e01c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.354127Z",
     "iopub.status.busy": "2022-11-09T17:18:46.352682Z",
     "iopub.status.idle": "2022-11-09T17:18:46.366250Z",
     "shell.execute_reply": "2022-11-09T17:18:46.364363Z"
    },
    "papermill": {
     "duration": 0.028884,
     "end_time": "2022-11-09T17:18:46.369643",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.340759",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Transactional amount on each day\n",
    "# Transactional amount for each channel grouping\n",
    "# Check for these others in channelGrouping and if its unimportant, remove it\n",
    "# Pie graph of percentage of device browsers\n",
    "# Transactions from each browser\n",
    "\n",
    "# Check relation between fullVIsitorID and visitID\n",
    "\n",
    "# Remove the whole column of SocvialEngagementType as it is useless\n",
    "# unique(data$socialEngagementType)\n",
    "\n",
    "# Remove the unwanted device_browser, device_os, device_category\n",
    "#rows after checking for its relation with the transaction amount\n",
    "\n",
    "# Map explaining the total transaction amount for each continent, sub_continent, country,\n",
    "# geo_info_network_domain\n",
    "\n",
    "\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 23,
   "id": "21cea66d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.393824Z",
     "iopub.status.busy": "2022-11-09T17:18:46.392335Z",
     "iopub.status.idle": "2022-11-09T17:18:46.411928Z",
     "shell.execute_reply": "2022-11-09T17:18:46.409715Z"
    },
    "papermill": {
     "duration": 0.035036,
     "end_time": "2022-11-09T17:18:46.414778",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.379742",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>20171016</li><li>20160902</li><li>20171130</li><li>20170126</li><li>20170623</li><li>20170312</li><li>20170203</li><li>20180415</li><li>20171110</li><li>20160811</li><li>20170613</li><li>20170113</li><li>20171111</li><li>20161118</li><li>20161110</li><li>20161112</li><li>20170621</li><li>20180117</li><li>20180103</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 20171016\n",
       "\\item 20160902\n",
       "\\item 20171130\n",
       "\\item 20170126\n",
       "\\item 20170623\n",
       "\\item 20170312\n",
       "\\item 20170203\n",
       "\\item 20180415\n",
       "\\item 20171110\n",
       "\\item 20160811\n",
       "\\item 20170613\n",
       "\\item 20170113\n",
       "\\item 20171111\n",
       "\\item 20161118\n",
       "\\item 20161110\n",
       "\\item 20161112\n",
       "\\item 20170621\n",
       "\\item 20180117\n",
       "\\item 20180103\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 20171016\n",
       "2. 20160902\n",
       "3. 20171130\n",
       "4. 20170126\n",
       "5. 20170623\n",
       "6. 20170312\n",
       "7. 20170203\n",
       "8. 20180415\n",
       "9. 20171110\n",
       "10. 20160811\n",
       "11. 20170613\n",
       "12. 20170113\n",
       "13. 20171111\n",
       "14. 20161118\n",
       "15. 20161110\n",
       "16. 20161112\n",
       "17. 20170621\n",
       "18. 20180117\n",
       "19. 20180103\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       " [1] 20171016 20160902 20171130 20170126 20170623 20170312 20170203 20180415\n",
       " [9] 20171110 20160811 20170613 20170113 20171111 20161118 20161110 20161112\n",
       "[17] 20170621 20180117 20180103"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "unique(data$date)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 24,
   "id": "56f5b5d3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.438677Z",
     "iopub.status.busy": "2022-11-09T17:18:46.437123Z",
     "iopub.status.idle": "2022-11-09T17:18:46.454652Z",
     "shell.execute_reply": "2022-11-09T17:18:46.452913Z"
    },
    "papermill": {
     "duration": 0.032434,
     "end_time": "2022-11-09T17:18:46.457323",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.424889",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "150"
      ],
      "text/latex": [
       "150"
      ],
      "text/markdown": [
       "150"
      ],
      "text/plain": [
       "[1] 150"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "length(unique(data$visitNumber))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 25,
   "id": "87e1b761",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.484268Z",
     "iopub.status.busy": "2022-11-09T17:18:46.481842Z",
     "iopub.status.idle": "2022-11-09T17:18:46.502398Z",
     "shell.execute_reply": "2022-11-09T17:18:46.500591Z"
    },
    "papermill": {
     "duration": 0.036719,
     "end_time": "2022-11-09T17:18:46.504795",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.468076",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "49042"
      ],
      "text/latex": [
       "49042"
      ],
      "text/markdown": [
       "49042"
      ],
      "text/plain": [
       "[1] 49042"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "length(unique(data$visitStartTime))"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 26,
   "id": "1f8f1f68",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.529364Z",
     "iopub.status.busy": "2022-11-09T17:18:46.527818Z",
     "iopub.status.idle": "2022-11-09T17:18:46.558974Z",
     "shell.execute_reply": "2022-11-09T17:18:46.556616Z"
    },
    "papermill": {
     "duration": 0.047583,
     "end_time": "2022-11-09T17:18:46.563104",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.515521",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Firefox 1911\"\n",
      "[1] \"Chrome 33986\"\n",
      "[1] \"Safari 10052\"\n",
      "[1] \"UC Browser 138\"\n",
      "[1] \"Internet Explorer 1138\"\n",
      "[1] \"Edge 583\"\n",
      "[1] \"Samsung Internet 295\"\n",
      "[1] \"Android Webview 583\"\n",
      "[1] \"Safari (in-app) 371\"\n",
      "[1] \"Opera Mini 428\"\n",
      "[1] \"Opera 281\"\n",
      "[1] \"YaBrowser 73\"\n",
      "[1] \"Amazon Silk 38\"\n",
      "[1] \"Mozilla Compatible Agent 17\"\n",
      "[1] \"Puffin 6\"\n",
      "[1] \"Maxthon 4\"\n",
      "[1] \"BlackBerry 8\"\n",
      "[1] \"ADM 1\"\n",
      "[1] \"Coc Coc 37\"\n",
      "[1] \"MRCHROME 8\"\n",
      "[1] \"Android Browser 22\"\n",
      "[1] \"Playstation Vita Browser 1\"\n",
      "[1] \"Nintendo Browser 7\"\n",
      "[1] \"Nokia Browser 5\"\n",
      "[1] \"SeaMonkey 1\"\n",
      "[1] \"Lunascape 1\"\n",
      "[1] \"IE with Chrome Frame 1\"\n",
      "[1] \"ThumbSniper 1\"\n",
      "[1] \"LYF_LS_4002_12 1\"\n",
      "[1] \"DESKTOP 2\"\n"
     ]
    }
   ],
   "source": [
    "for(i in unique(data$device_browser)){\n",
    "    print(paste(i, sum(data$device_browser == i)))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 27,
   "id": "965162ce",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.588598Z",
     "iopub.status.busy": "2022-11-09T17:18:46.587050Z",
     "iopub.status.idle": "2022-11-09T17:18:46.615930Z",
     "shell.execute_reply": "2022-11-09T17:18:46.613172Z"
    },
    "papermill": {
     "duration": 0.044684,
     "end_time": "2022-11-09T17:18:46.619552",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.574868",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Windows 19247\"\n",
      "[1] \"Chrome OS 1507\"\n",
      "[1] \"Android 7324\"\n",
      "[1] \"Macintosh 13596\"\n",
      "[1] \"iOS 5997\"\n",
      "[1] \"Linux 1830\"\n",
      "[1] \"(not set) 337\"\n",
      "[1] \"Windows Phone 74\"\n",
      "[1] \"Samsung 27\"\n",
      "[1] \"Tizen 24\"\n",
      "[1] \"BlackBerry 8\"\n",
      "[1] \"OS/2 9\"\n",
      "[1] \"Playstation Vita 1\"\n",
      "[1] \"Xbox 9\"\n",
      "[1] \"Nintendo Wii 6\"\n",
      "[1] \"Firefox OS 3\"\n",
      "[1] \"Nintendo 3DS 1\"\n"
     ]
    }
   ],
   "source": [
    "for(i in unique(data$device_os)){\n",
    "    print(paste(i, sum(data$device_os == i)))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 28,
   "id": "543b7d56",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.644686Z",
     "iopub.status.busy": "2022-11-09T17:18:46.643171Z",
     "iopub.status.idle": "2022-11-09T17:18:46.667529Z",
     "shell.execute_reply": "2022-11-09T17:18:46.664666Z"
    },
    "papermill": {
     "duration": 0.040749,
     "end_time": "2022-11-09T17:18:46.671179",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.630430",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"desktop 36124\"\n",
      "[1] \"mobile 12258\"\n",
      "[1] \"tablet 1618\"\n"
     ]
    }
   ],
   "source": [
    "for(i in unique(data$device_category)){\n",
    "    print(paste(i, sum(data$device_category == i)))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 29,
   "id": "7b9ac776",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.697365Z",
     "iopub.status.busy": "2022-11-09T17:18:46.695685Z",
     "iopub.status.idle": "2022-11-09T17:18:46.733716Z",
     "shell.execute_reply": "2022-11-09T17:18:46.729621Z"
    },
    "papermill": {
     "duration": 0.055027,
     "end_time": "2022-11-09T17:18:46.737201",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.682174",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>'Europe'</li><li>'Americas'</li><li>'Asia'</li><li>'Oceania'</li><li>'(not set)'</li><li>'Africa'</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 'Europe'\n",
       "\\item 'Americas'\n",
       "\\item 'Asia'\n",
       "\\item 'Oceania'\n",
       "\\item '(not set)'\n",
       "\\item 'Africa'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 'Europe'\n",
       "2. 'Americas'\n",
       "3. 'Asia'\n",
       "4. 'Oceania'\n",
       "5. '(not set)'\n",
       "6. 'Africa'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       "[1] \"Europe\"    \"Americas\"  \"Asia\"      \"Oceania\"   \"(not set)\" \"Africa\"   "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Europe 11122\"\n",
      "[1] \"Americas 24313\"\n",
      "[1] \"Asia 12836\"\n",
      "[1] \"Oceania 754\"\n",
      "[1] \"(not set) 73\"\n",
      "[1] \"Africa 902\"\n"
     ]
    }
   ],
   "source": [
    "unique(data$geo_info_continent)\n",
    "for(i in unique(data$geo_info_continent)){\n",
    "    print(paste(i, sum(data$geo_info_continent == i)))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 30,
   "id": "aabf1409",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.764302Z",
     "iopub.status.busy": "2022-11-09T17:18:46.762479Z",
     "iopub.status.idle": "2022-11-09T17:18:46.799879Z",
     "shell.execute_reply": "2022-11-09T17:18:46.797684Z"
    },
    "papermill": {
     "duration": 0.053449,
     "end_time": "2022-11-09T17:18:46.802694",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.749245",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<style>\n",
       ".list-inline {list-style: none; margin:0; padding: 0}\n",
       ".list-inline>li {display: inline-block}\n",
       ".list-inline>li:not(:last-child)::after {content: \"\\00b7\"; padding: 0 .5ex}\n",
       "</style>\n",
       "<ol class=list-inline><li>'Western Europe'</li><li>'Northern America'</li><li>'Western Asia'</li><li>'Central America'</li><li>'Northern Europe'</li><li>'Southern Asia'</li><li>'Southeast Asia'</li><li>'Eastern Europe'</li><li>'South America'</li><li>'Eastern Asia'</li><li>'Southern Europe'</li><li>'Australasia'</li><li>'Central Asia'</li><li>'(not set)'</li><li>'Northern Africa'</li><li>'Eastern Africa'</li><li>'Southern Africa'</li><li>'Western Africa'</li><li>'Caribbean'</li><li>'Middle Africa'</li><li>'Melanesia'</li><li>'Micronesian Region'</li><li>'Polynesia'</li></ol>\n"
      ],
      "text/latex": [
       "\\begin{enumerate*}\n",
       "\\item 'Western Europe'\n",
       "\\item 'Northern America'\n",
       "\\item 'Western Asia'\n",
       "\\item 'Central America'\n",
       "\\item 'Northern Europe'\n",
       "\\item 'Southern Asia'\n",
       "\\item 'Southeast Asia'\n",
       "\\item 'Eastern Europe'\n",
       "\\item 'South America'\n",
       "\\item 'Eastern Asia'\n",
       "\\item 'Southern Europe'\n",
       "\\item 'Australasia'\n",
       "\\item 'Central Asia'\n",
       "\\item '(not set)'\n",
       "\\item 'Northern Africa'\n",
       "\\item 'Eastern Africa'\n",
       "\\item 'Southern Africa'\n",
       "\\item 'Western Africa'\n",
       "\\item 'Caribbean'\n",
       "\\item 'Middle Africa'\n",
       "\\item 'Melanesia'\n",
       "\\item 'Micronesian Region'\n",
       "\\item 'Polynesia'\n",
       "\\end{enumerate*}\n"
      ],
      "text/markdown": [
       "1. 'Western Europe'\n",
       "2. 'Northern America'\n",
       "3. 'Western Asia'\n",
       "4. 'Central America'\n",
       "5. 'Northern Europe'\n",
       "6. 'Southern Asia'\n",
       "7. 'Southeast Asia'\n",
       "8. 'Eastern Europe'\n",
       "9. 'South America'\n",
       "10. 'Eastern Asia'\n",
       "11. 'Southern Europe'\n",
       "12. 'Australasia'\n",
       "13. 'Central Asia'\n",
       "14. '(not set)'\n",
       "15. 'Northern Africa'\n",
       "16. 'Eastern Africa'\n",
       "17. 'Southern Africa'\n",
       "18. 'Western Africa'\n",
       "19. 'Caribbean'\n",
       "20. 'Middle Africa'\n",
       "21. 'Melanesia'\n",
       "22. 'Micronesian Region'\n",
       "23. 'Polynesia'\n",
       "\n",
       "\n"
      ],
      "text/plain": [
       " [1] \"Western Europe\"     \"Northern America\"   \"Western Asia\"      \n",
       " [4] \"Central America\"    \"Northern Europe\"    \"Southern Asia\"     \n",
       " [7] \"Southeast Asia\"     \"Eastern Europe\"     \"South America\"     \n",
       "[10] \"Eastern Asia\"       \"Southern Europe\"    \"Australasia\"       \n",
       "[13] \"Central Asia\"       \"(not set)\"          \"Northern Africa\"   \n",
       "[16] \"Eastern Africa\"     \"Southern Africa\"    \"Western Africa\"    \n",
       "[19] \"Caribbean\"          \"Middle Africa\"      \"Melanesia\"         \n",
       "[22] \"Micronesian Region\" \"Polynesia\"         "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Western Europe 3466\"\n",
      "[1] \"Northern America 20954\"\n",
      "[1] \"Western Asia 2014\"\n",
      "[1] \"Central America 895\"\n",
      "[1] \"Northern Europe 3109\"\n",
      "[1] \"Southern Asia 3508\"\n",
      "[1] \"Southeast Asia 4650\"\n",
      "[1] \"Eastern Europe 2652\"\n",
      "[1] \"South America 2344\"\n",
      "[1] \"Eastern Asia 2595\"\n",
      "[1] \"Southern Europe 1895\"\n",
      "[1] \"Australasia 747\"\n",
      "[1] \"Central Asia 69\"\n",
      "[1] \"(not set) 73\"\n",
      "[1] \"Northern Africa 413\"\n",
      "[1] \"Eastern Africa 131\"\n",
      "[1] \"Southern Africa 139\"\n",
      "[1] \"Western Africa 185\"\n",
      "[1] \"Caribbean 120\"\n",
      "[1] \"Middle Africa 34\"\n",
      "[1] \"Melanesia 3\"\n",
      "[1] \"Micronesian Region 3\"\n",
      "[1] \"Polynesia 1\"\n"
     ]
    }
   ],
   "source": [
    "unique(data$geo_info_sub_continent)\n",
    "for(i in unique(data$geo_info_sub_continent)){\n",
    "    print(paste(i, sum(data$geo_info_sub_continent == i)))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 31,
   "id": "19917923",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.828523Z",
     "iopub.status.busy": "2022-11-09T17:18:46.827126Z",
     "iopub.status.idle": "2022-11-09T17:18:46.909308Z",
     "shell.execute_reply": "2022-11-09T17:18:46.906205Z"
    },
    "papermill": {
     "duration": 0.098801,
     "end_time": "2022-11-09T17:18:46.912867",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.814066",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Germany 1111\"\n",
      "[1] \"United States 19533\"\n",
      "[1] \"Turkey 1049\"\n",
      "[1] \"Mexico 792\"\n",
      "[1] \"United Kingdom 2071\"\n",
      "[1] \"Denmark 148\"\n",
      "[1] \"Netherlands 768\"\n",
      "[1] \"Sweden 262\"\n",
      "[1] \"Canada 1419\"\n",
      "[1] \"India 3058\"\n",
      "[1] \"Belgium 301\"\n",
      "[1] \"Philippines 470\"\n",
      "[1] \"Slovakia 90\"\n",
      "[1] \"Brazil 1187\"\n",
      "[1] \"Japan 1044\"\n",
      "[1] \"Taiwan 804\"\n",
      "[1] \"Peru 332\"\n",
      "[1] \"Ireland 363\"\n",
      "[1] \"Norway 121\"\n",
      "[1] \"Romania 577\"\n",
      "[1] \"Russia 554\"\n",
      "[1] \"Italy 599\"\n",
      "[1] \"New Zealand 120\"\n",
      "[1] \"Czechia 321\"\n",
      "[1] \"Serbia 98\"\n",
      "[1] \"Argentina 299\"\n",
      "[1] \"Australia 627\"\n",
      "[1] \"Hong Kong 218\"\n",
      "[1] \"Indonesia 486\"\n",
      "[1] \"Singapore 422\"\n",
      "[1] \"Kazakhstan 57\"\n",
      "[1] \"Thailand 1151\"\n",
      "[1] \"Ecuador 50\"\n",
      "[1] \"Switzerland 226\"\n",
      "[1] \"Spain 680\"\n",
      "[1] \"France 906\"\n",
      "[1] \"Malaysia 365\"\n",
      "[1] \"Poland 522\"\n",
      "[1] \"Bulgaria 87\"\n",
      "[1] \"Jordan 35\"\n",
      "[1] \"China 209\"\n",
      "[1] \"Pakistan 213\"\n",
      "[1] \"(not set) 73\"\n",
      "[1] \"Israel 287\"\n",
      "[1] \"Vietnam 1695\"\n",
      "[1] \"Bangladesh 146\"\n",
      "[1] \"Greece 128\"\n",
      "[1] \"Algeria 110\"\n",
      "[1] \"Georgia 49\"\n",
      "[1] \"Ukraine 306\"\n",
      "[1] \"South Korea 303\"\n",
      "[1] \"Austria 146\"\n",
      "[1] \"Ethiopia 24\"\n",
      "[1] \"Colombia 243\"\n",
      "[1] \"Sudan 4\"\n",
      "[1] \"Egypt 135\"\n",
      "[1] \"United Arab Emirates 172\"\n",
      "[1] \"Panama 21\"\n",
      "[1] \"Portugal 147\"\n",
      "[1] \"Latvia 22\"\n",
      "[1] \"Chile 94\"\n",
      "[1] \"Belarus 45\"\n",
      "[1] \"South Africa 132\"\n",
      "[1] \"El Salvador 12\"\n",
      "[1] \"Nigeria 117\"\n",
      "[1] \"Venezuela 88\"\n",
      "[1] \"Sri Lanka 76\"\n",
      "[1] \"Estonia 22\"\n",
      "[1] \"Croatia 70\"\n",
      "[1] \"Myanmar (Burma) 15\"\n",
      "[1] \"Lithuania 52\"\n",
      "[1] \"Armenia 15\"\n",
      "[1] \"Puerto Rico 34\"\n",
      "[1] \"Saudi Arabia 181\"\n",
      "[1] \"Dominican Republic 44\"\n",
      "[1] \"Finland 40\"\n",
      "[1] \"Hungary 135\"\n",
      "[1] \"Cambodia 35\"\n",
      "[1] \"Qatar 28\"\n",
      "[1] \"Tunisia 55\"\n",
      "[1] \"Morocco 100\"\n",
      "[1] \"Mongolia 11\"\n",
      "[1] \"Rwanda 3\"\n",
      "[1] \"Afghanistan 3\"\n",
      "[1] \"Trinidad & Tobago 10\"\n",
      "[1] \"Bolivia 17\"\n",
      "[1] \"Zambia 3\"\n",
      "[1] \"Iraq 38\"\n",
      "[1] \"Guatemala 31\"\n",
      "[1] \"Honduras 11\"\n",
      "[1] \"Yemen 10\"\n",
      "[1] \"Tanzania 22\"\n",
      "[1] \"Oman 26\"\n",
      "[1] \"Greenland 2\"\n",
      "[1] \"Kuwait 28\"\n",
      "[1] \"French Guiana 3\"\n",
      "[1] \"Réunion 8\"\n",
      "[1] \"Kosovo 21\"\n",
      "[1] \"Curaçao 2\"\n",
      "[1] \"Malta 13\"\n",
      "[1] \"Montenegro 5\"\n",
      "[1] \"Slovenia 33\"\n",
      "[1] \"Kenya 40\"\n",
      "[1] \"Moldova 15\"\n",
      "[1] \"Costa Rica 23\"\n",
      "[1] \"Bosnia & Herzegovina 37\"\n",
      "[1] \"Paraguay 5\"\n",
      "[1] \"Botswana 2\"\n",
      "[1] \"Uruguay 23\"\n",
      "[1] \"Jamaica 19\"\n",
      "[1] \"Gambia 3\"\n",
      "[1] \"Madagascar 5\"\n",
      "[1] \"Togo 1\"\n",
      "[1] \"Lebanon 14\"\n",
      "[1] \"Libya 9\"\n",
      "[1] \"Uzbekistan 5\"\n",
      "[1] \"Mauritius 5\"\n",
      "[1] \"Cyprus 15\"\n",
      "[1] \"Macedonia (FYROM) 39\"\n",
      "[1] \"Albania 24\"\n",
      "[1] \"Bahrain 14\"\n",
      "[1] \"Turks & Caicos Islands 1\"\n",
      "[1] \"Zimbabwe 2\"\n",
      "[1] \"Ghana 17\"\n",
      "[1] \"Cape Verde 1\"\n",
      "[1] \"Senegal 10\"\n",
      "[1] \"Côte d’Ivoire 17\"\n",
      "[1] \"Laos 9\"\n",
      "[1] \"Azerbaijan 32\"\n",
      "[1] \"Barbados 3\"\n",
      "[1] \"Uganda 12\"\n",
      "[1] \"Nepal 10\"\n",
      "[1] \"Mali 5\"\n",
      "[1] \"Mauritania 1\"\n",
      "[1] \"Nicaragua 3\"\n",
      "[1] \"Iceland 8\"\n",
      "[1] \"Palestine 21\"\n",
      "[1] \"Haiti 2\"\n",
      "[1] \"St. Kitts & Nevis 1\"\n",
      "[1] \"Somalia 3\"\n",
      "[1] \"Cameroon 14\"\n",
      "[1] \"Namibia 5\"\n",
      "[1] \"Congo - Kinshasa 11\"\n",
      "[1] \"New Caledonia 2\"\n",
      "[1] \"Kyrgyzstan 6\"\n",
      "[1] \"Luxembourg 8\"\n",
      "[1] \"Benin 4\"\n",
      "[1] \"Guinea 3\"\n",
      "[1] \"Guam 3\"\n",
      "[1] \"San Marino 1\"\n",
      "[1] \"Liberia 1\"\n",
      "[1] \"Malawi 1\"\n",
      "[1] \"Angola 5\"\n",
      "[1] \"Guyana 3\"\n",
      "[1] \"Brunei 2\"\n",
      "[1] \"Guadeloupe 2\"\n",
      "[1] \"Belize 2\"\n",
      "[1] \"Maldives 2\"\n",
      "[1] \"Guinea-Bissau 1\"\n",
      "[1] \"Mozambique 3\"\n",
      "[1] \"Gabon 3\"\n",
      "[1] \"Macau 6\"\n",
      "[1] \"Burkina Faso 4\"\n",
      "[1] \"Tajikistan 1\"\n",
      "[1] \"Martinique 2\"\n",
      "[1] \"Congo - Brazzaville 1\"\n",
      "[1] \"French Polynesia 1\"\n",
      "[1] \"Fiji 1\"\n"
     ]
    }
   ],
   "source": [
    "# unique(data$geo_info_country)\n",
    "for(i in unique(data$geo_info_country)){\n",
    "    print(paste(i, sum(data$geo_info_country == i)))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 32,
   "id": "d33c3af3",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:46.941374Z",
     "iopub.status.busy": "2022-11-09T17:18:46.939313Z",
     "iopub.status.idle": "2022-11-09T17:18:48.479640Z",
     "shell.execute_reply": "2022-11-09T17:18:48.476767Z"
    },
    "papermill": {
     "duration": 1.558288,
     "end_time": "2022-11-09T17:18:48.483603",
     "exception": false,
     "start_time": "2022-11-09T17:18:46.925315",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"(not set) 13690\"\n",
      "[1] \"unknown.unknown 8434\"\n",
      "[1] \"prod-infinitum.com.mx 328\"\n",
      "[1] \"bhn.net 154\"\n",
      "[1] \"att.net 274\"\n",
      "[1] \"virginm.net 363\"\n",
      "[1] \"btcentralplus.com 265\"\n",
      "[1] \"pldt.net 205\"\n",
      "[1] \"comcast.net 1467\"\n",
      "[1] \"comcastbusiness.net 476\"\n",
      "[1] \"rdsnet.ro 211\"\n",
      "[1] \"shawcable.net 145\"\n",
      "[1] \"bell.ca 154\"\n",
      "[1] \"qwest.net 229\"\n",
      "[1] \"verizon.net 695\"\n",
      "[1] \"videotron.ca 114\"\n",
      "[1] \"virtua.com.br 176\"\n",
      "[1] \"optonline.net 267\"\n",
      "[1] \"3bb.co.th 322\"\n",
      "[1] \"hinet.net 464\"\n",
      "[1] \"telecomitalia.it 182\"\n",
      "[1] \"actcorp.in 144\"\n",
      "[1] \"rima-tde.net 230\"\n",
      "[1] \"t-ipconnect.de 163\"\n",
      "[1] \"com 110\"\n",
      "[1] \"cox.net 312\"\n",
      "[1] \"rr.com 767\"\n",
      "[1] \"ttnet.com.tr 682\"\n",
      "[1] \"airtelbroadband.in 189\"\n",
      "[1] \"sfr.net 157\"\n",
      "[1] \"amazonaws.com 180\"\n",
      "[1] \"proxad.net 107\"\n",
      "[1] \"sbcglobal.net 284\"\n",
      "[1] \"vnpt.vn 345\"\n",
      "[1] \"spcsdns.net 106\"\n",
      "[1] \"totbb.net 292\"\n",
      "[1] \"superonline.net 118\"\n",
      "[1] \"gvt.net.br 116\"\n",
      "[1] \"asianet.co.th 252\"\n",
      "[1] \"bezeqint.net 109\"\n",
      "[1] \"google.com 312\"\n",
      "[1] \"ocn.ne.jp 101\"\n",
      "[1] \"wanadoo.fr 144\"\n"
     ]
    }
   ],
   "source": [
    "# unique(data$geo_info_network_domain)\n",
    "for(i in unique(data$geo_info_network_domain)){\n",
    "    if(sum(data$geo_info_network_domain == i) > 100)\n",
    "    print(paste(i, sum(data$geo_info_network_domain == i)))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 33,
   "id": "49500287",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-09T17:18:48.511088Z",
     "iopub.status.busy": "2022-11-09T17:18:48.509577Z",
     "iopub.status.idle": "2022-11-09T17:18:48.522426Z",
     "shell.execute_reply": "2022-11-09T17:18:48.520827Z"
    },
    "papermill": {
     "duration": 0.029713,
     "end_time": "2022-11-09T17:18:48.525410",
     "exception": false,
     "start_time": "2022-11-09T17:18:48.495697",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# Completed till geo_info. Need to complete the rest"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "061f10aa",
   "metadata": {
    "papermill": {
     "duration": 0.011524,
     "end_time": "2022-11-09T17:18:48.548979",
     "exception": false,
     "start_time": "2022-11-09T17:18:48.537455",
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
   "duration": 237.838711,
   "end_time": "2022-11-09T17:18:48.783629",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-11-09T17:14:50.944918",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
