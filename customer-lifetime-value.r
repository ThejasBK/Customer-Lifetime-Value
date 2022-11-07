{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "b6ef4fd0",
   "metadata": {
    "papermill": {
     "duration": 0.005043,
     "end_time": "2022-11-07T03:09:45.851589",
     "exception": false,
     "start_time": "2022-11-07T03:09:45.846546",
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
   "id": "0303afb8",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:45.863097Z",
     "iopub.status.busy": "2022-11-07T03:09:45.861121Z",
     "iopub.status.idle": "2022-11-07T03:09:46.019787Z",
     "shell.execute_reply": "2022-11-07T03:09:46.018027Z"
    },
    "papermill": {
     "duration": 0.172813,
     "end_time": "2022-11-07T03:09:46.028328",
     "exception": false,
     "start_time": "2022-11-07T03:09:45.855515",
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
    "library(jsonlite)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "f8f0004e",
   "metadata": {
    "_cell_guid": "b1076dfc-b9ad-4769-8c92-a6c4dae69d19",
    "_uuid": "8f2839f25d086af736a60e9eeb907d3b93b6e0e5",
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:46.070099Z",
     "iopub.status.busy": "2022-11-07T03:09:46.038192Z",
     "iopub.status.idle": "2022-11-07T03:09:51.160022Z",
     "shell.execute_reply": "2022-11-07T03:09:51.157546Z"
    },
    "papermill": {
     "duration": 5.130444,
     "end_time": "2022-11-07T03:09:51.162695",
     "exception": false,
     "start_time": "2022-11-07T03:09:46.032251",
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
   "id": "0a16d0ec",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:51.174278Z",
     "iopub.status.busy": "2022-11-07T03:09:51.172680Z",
     "iopub.status.idle": "2022-11-07T03:09:51.192466Z",
     "shell.execute_reply": "2022-11-07T03:09:51.190750Z"
    },
    "papermill": {
     "duration": 0.027964,
     "end_time": "2022-11-07T03:09:51.194850",
     "exception": false,
     "start_time": "2022-11-07T03:09:51.166886",
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
   "id": "73b1c932",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:51.206639Z",
     "iopub.status.busy": "2022-11-07T03:09:51.205119Z",
     "iopub.status.idle": "2022-11-07T03:09:51.241521Z",
     "shell.execute_reply": "2022-11-07T03:09:51.239794Z"
    },
    "papermill": {
     "duration": 0.045005,
     "end_time": "2022-11-07T03:09:51.243792",
     "exception": false,
     "start_time": "2022-11-07T03:09:51.198787",
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
   "id": "2b1932be",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:51.256068Z",
     "iopub.status.busy": "2022-11-07T03:09:51.254595Z",
     "iopub.status.idle": "2022-11-07T03:09:52.794975Z",
     "shell.execute_reply": "2022-11-07T03:09:52.793177Z"
    },
    "papermill": {
     "duration": 1.549828,
     "end_time": "2022-11-07T03:09:52.798068",
     "exception": false,
     "start_time": "2022-11-07T03:09:51.248240",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "device_info <- lapply(data$device, fromJSON)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "b08a1c02",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:52.810364Z",
     "iopub.status.busy": "2022-11-07T03:09:52.808885Z",
     "iopub.status.idle": "2022-11-07T03:09:52.833791Z",
     "shell.execute_reply": "2022-11-07T03:09:52.832028Z"
    },
    "papermill": {
     "duration": 0.033743,
     "end_time": "2022-11-07T03:09:52.836147",
     "exception": false,
     "start_time": "2022-11-07T03:09:52.802404",
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
    "device_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "45ed4fe7",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:52.849742Z",
     "iopub.status.busy": "2022-11-07T03:09:52.848161Z",
     "iopub.status.idle": "2022-11-07T03:09:54.121765Z",
     "shell.execute_reply": "2022-11-07T03:09:54.119928Z"
    },
    "papermill": {
     "duration": 1.283056,
     "end_time": "2022-11-07T03:09:54.124265",
     "exception": false,
     "start_time": "2022-11-07T03:09:52.841209",
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
   "execution_count": 8,
   "id": "bbd5d006",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:54.137404Z",
     "iopub.status.busy": "2022-11-07T03:09:54.135803Z",
     "iopub.status.idle": "2022-11-07T03:09:55.307157Z",
     "shell.execute_reply": "2022-11-07T03:09:55.305325Z"
    },
    "papermill": {
     "duration": 1.180589,
     "end_time": "2022-11-07T03:09:55.309572",
     "exception": false,
     "start_time": "2022-11-07T03:09:54.128983",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "geo_network_info <- lapply(data$geoNetwork, fromJSON)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "639e34d4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:55.323633Z",
     "iopub.status.busy": "2022-11-07T03:09:55.321995Z",
     "iopub.status.idle": "2022-11-07T03:09:55.342830Z",
     "shell.execute_reply": "2022-11-07T03:09:55.341123Z"
    },
    "papermill": {
     "duration": 0.030383,
     "end_time": "2022-11-07T03:09:55.345209",
     "exception": false,
     "start_time": "2022-11-07T03:09:55.314826",
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
    "geo_network_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "7135ab5f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:55.359751Z",
     "iopub.status.busy": "2022-11-07T03:09:55.358028Z",
     "iopub.status.idle": "2022-11-07T03:09:55.378872Z",
     "shell.execute_reply": "2022-11-07T03:09:55.376543Z"
    },
    "papermill": {
     "duration": 0.037401,
     "end_time": "2022-11-07T03:09:55.387983",
     "exception": false,
     "start_time": "2022-11-07T03:09:55.350582",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "$continent\n",
      "[1] \"Europe\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Western Europe\"\n",
      "\n",
      "$country\n",
      "[1] \"Germany\"\n",
      "\n",
      "$region\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$metro\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$city\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"(not set)\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Americas\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Northern America\"\n",
      "\n",
      "$country\n",
      "[1] \"United States\"\n",
      "\n",
      "$region\n",
      "[1] \"California\"\n",
      "\n",
      "$metro\n",
      "[1] \"San Francisco-Oakland-San Jose CA\"\n",
      "\n",
      "$city\n",
      "[1] \"Cupertino\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"(not set)\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Americas\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Northern America\"\n",
      "\n",
      "$country\n",
      "[1] \"United States\"\n",
      "\n",
      "$region\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$metro\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$city\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"windjammercable.net\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Asia\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Western Asia\"\n",
      "\n",
      "$country\n",
      "[1] \"Turkey\"\n",
      "\n",
      "$region\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$metro\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$city\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"unknown.unknown\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Americas\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Central America\"\n",
      "\n",
      "$country\n",
      "[1] \"Mexico\"\n",
      "\n",
      "$region\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$metro\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$city\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"prod-infinitum.com.mx\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Americas\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Northern America\"\n",
      "\n",
      "$country\n",
      "[1] \"United States\"\n",
      "\n",
      "$region\n",
      "[1] \"California\"\n",
      "\n",
      "$metro\n",
      "[1] \"San Francisco-Oakland-San Jose CA\"\n",
      "\n",
      "$city\n",
      "[1] \"San Francisco\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"unknown.unknown\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Europe\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Northern Europe\"\n",
      "\n",
      "$country\n",
      "[1] \"United Kingdom\"\n",
      "\n",
      "$region\n",
      "[1] \"England\"\n",
      "\n",
      "$metro\n",
      "[1] \"London\"\n",
      "\n",
      "$city\n",
      "[1] \"London\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"(not set)\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Europe\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Northern Europe\"\n",
      "\n",
      "$country\n",
      "[1] \"Denmark\"\n",
      "\n",
      "$region\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$metro\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$city\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"fullrate.ninja\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Americas\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Central America\"\n",
      "\n",
      "$country\n",
      "[1] \"Mexico\"\n",
      "\n",
      "$region\n",
      "[1] \"Mexico City\"\n",
      "\n",
      "$metro\n",
      "[1] \"(not set)\"\n",
      "\n",
      "$city\n",
      "[1] \"Mexico City\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"uninet-ide.com.mx\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$continent\n",
      "[1] \"Europe\"\n",
      "\n",
      "$subContinent\n",
      "[1] \"Western Europe\"\n",
      "\n",
      "$country\n",
      "[1] \"Netherlands\"\n",
      "\n",
      "$region\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$metro\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$city\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$cityId\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkDomain\n",
      "[1] \"(not set)\"\n",
      "\n",
      "$latitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$longitude\n",
      "[1] \"not available in demo dataset\"\n",
      "\n",
      "$networkLocation\n",
      "[1] \"not available in demo dataset\"\n",
      "\n"
     ]
    }
   ],
   "source": [
    "for(i in geo_network_info[1:10]) {\n",
    "    print(i)\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "bb58ccf5",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:55.402806Z",
     "iopub.status.busy": "2022-11-07T03:09:55.401348Z",
     "iopub.status.idle": "2022-11-07T03:09:55.413848Z",
     "shell.execute_reply": "2022-11-07T03:09:55.412235Z"
    },
    "papermill": {
     "duration": 0.022903,
     "end_time": "2022-11-07T03:09:55.416842",
     "exception": false,
     "start_time": "2022-11-07T03:09:55.393939",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# hits_info <- lapply(data$hits, fromJSON)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "0952c5af",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:55.431103Z",
     "iopub.status.busy": "2022-11-07T03:09:55.429595Z",
     "iopub.status.idle": "2022-11-07T03:09:55.442218Z",
     "shell.execute_reply": "2022-11-07T03:09:55.440640Z"
    },
    "papermill": {
     "duration": 0.023025,
     "end_time": "2022-11-07T03:09:55.445203",
     "exception": false,
     "start_time": "2022-11-07T03:09:55.422178",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# totals_info <- lapply(data$totals, fromJSON)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "ff8bc734",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:55.459646Z",
     "iopub.status.busy": "2022-11-07T03:09:55.458157Z",
     "iopub.status.idle": "2022-11-07T03:09:55.470108Z",
     "shell.execute_reply": "2022-11-07T03:09:55.468501Z"
    },
    "papermill": {
     "duration": 0.022282,
     "end_time": "2022-11-07T03:09:55.472960",
     "exception": false,
     "start_time": "2022-11-07T03:09:55.450678",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# count <- 0\n",
    "# for(i in totals_info) #totalTransactionRevenue\n",
    "#     if(length(i$totalTransactionRevenue)) {\n",
    "# #         print(i$totalTransactionRevenue)\n",
    "#         count <- count + 1\n",
    "#     }"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "ea082f7e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:09:55.488311Z",
     "iopub.status.busy": "2022-11-07T03:09:55.486699Z",
     "iopub.status.idle": "2022-11-07T03:09:55.499221Z",
     "shell.execute_reply": "2022-11-07T03:09:55.497324Z"
    },
    "papermill": {
     "duration": 0.022811,
     "end_time": "2022-11-07T03:09:55.501649",
     "exception": false,
     "start_time": "2022-11-07T03:09:55.478838",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# data"
   ]
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
   "duration": 13.778954,
   "end_time": "2022-11-07T03:09:55.631371",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-11-07T03:09:41.852417",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
