{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "d713147d",
   "metadata": {
    "papermill": {
     "duration": 0.003909,
     "end_time": "2022-11-07T03:32:44.011117",
     "exception": false,
     "start_time": "2022-11-07T03:32:44.007208",
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
   "id": "722b23ae",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:44.021823Z",
     "iopub.status.busy": "2022-11-07T03:32:44.019674Z",
     "iopub.status.idle": "2022-11-07T03:32:44.190916Z",
     "shell.execute_reply": "2022-11-07T03:32:44.189329Z"
    },
    "papermill": {
     "duration": 0.185234,
     "end_time": "2022-11-07T03:32:44.199390",
     "exception": false,
     "start_time": "2022-11-07T03:32:44.014156",
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
   "id": "5d42a6a3",
   "metadata": {
    "_cell_guid": "b1076dfc-b9ad-4769-8c92-a6c4dae69d19",
    "_uuid": "8f2839f25d086af736a60e9eeb907d3b93b6e0e5",
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:44.244900Z",
     "iopub.status.busy": "2022-11-07T03:32:44.208243Z",
     "iopub.status.idle": "2022-11-07T03:32:49.795547Z",
     "shell.execute_reply": "2022-11-07T03:32:49.793481Z"
    },
    "papermill": {
     "duration": 5.596393,
     "end_time": "2022-11-07T03:32:49.799332",
     "exception": false,
     "start_time": "2022-11-07T03:32:44.202939",
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
   "id": "adf03831",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:49.813013Z",
     "iopub.status.busy": "2022-11-07T03:32:49.811728Z",
     "iopub.status.idle": "2022-11-07T03:32:49.833868Z",
     "shell.execute_reply": "2022-11-07T03:32:49.831678Z"
    },
    "papermill": {
     "duration": 0.030518,
     "end_time": "2022-11-07T03:32:49.836295",
     "exception": false,
     "start_time": "2022-11-07T03:32:49.805777",
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
   "id": "2d07ce3e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:49.846922Z",
     "iopub.status.busy": "2022-11-07T03:32:49.845269Z",
     "iopub.status.idle": "2022-11-07T03:32:49.879534Z",
     "shell.execute_reply": "2022-11-07T03:32:49.877374Z"
    },
    "papermill": {
     "duration": 0.042012,
     "end_time": "2022-11-07T03:32:49.881922",
     "exception": false,
     "start_time": "2022-11-07T03:32:49.839910",
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
   "id": "5c5a2a39",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:49.892649Z",
     "iopub.status.busy": "2022-11-07T03:32:49.891311Z",
     "iopub.status.idle": "2022-11-07T03:32:51.203984Z",
     "shell.execute_reply": "2022-11-07T03:32:51.202096Z"
    },
    "papermill": {
     "duration": 1.320182,
     "end_time": "2022-11-07T03:32:51.206134",
     "exception": false,
     "start_time": "2022-11-07T03:32:49.885952",
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
    "\n",
    "device_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "f98ead3d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:51.216822Z",
     "iopub.status.busy": "2022-11-07T03:32:51.215549Z",
     "iopub.status.idle": "2022-11-07T03:32:52.192430Z",
     "shell.execute_reply": "2022-11-07T03:32:52.190983Z"
    },
    "papermill": {
     "duration": 0.984967,
     "end_time": "2022-11-07T03:32:52.194897",
     "exception": false,
     "start_time": "2022-11-07T03:32:51.209930",
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
   "id": "8b58315e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:52.205935Z",
     "iopub.status.busy": "2022-11-07T03:32:52.204718Z",
     "iopub.status.idle": "2022-11-07T03:32:53.176771Z",
     "shell.execute_reply": "2022-11-07T03:32:53.174695Z"
    },
    "papermill": {
     "duration": 0.980224,
     "end_time": "2022-11-07T03:32:53.179277",
     "exception": false,
     "start_time": "2022-11-07T03:32:52.199053",
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
    "\n",
    "geo_network_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "510593d4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:53.191039Z",
     "iopub.status.busy": "2022-11-07T03:32:53.189491Z",
     "iopub.status.idle": "2022-11-07T03:32:54.772014Z",
     "shell.execute_reply": "2022-11-07T03:32:54.770604Z"
    },
    "papermill": {
     "duration": 1.590951,
     "end_time": "2022-11-07T03:32:54.774404",
     "exception": false,
     "start_time": "2022-11-07T03:32:53.183453",
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
   "id": "08e333f7",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:54.785559Z",
     "iopub.status.busy": "2022-11-07T03:32:54.784379Z",
     "iopub.status.idle": "2022-11-07T03:32:54.793581Z",
     "shell.execute_reply": "2022-11-07T03:32:54.792248Z"
    },
    "papermill": {
     "duration": 0.017096,
     "end_time": "2022-11-07T03:32:54.795866",
     "exception": false,
     "start_time": "2022-11-07T03:32:54.778770",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# TODO: Need to do the above two steps for hits, totals, and trafficSource"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "ace39733",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:54.806661Z",
     "iopub.status.busy": "2022-11-07T03:32:54.805487Z",
     "iopub.status.idle": "2022-11-07T03:32:55.450473Z",
     "shell.execute_reply": "2022-11-07T03:32:55.449126Z"
    },
    "papermill": {
     "duration": 0.652461,
     "end_time": "2022-11-07T03:32:55.452394",
     "exception": false,
     "start_time": "2022-11-07T03:32:54.799933",
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
    "\n",
    "totals_info[1]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "a7b10b7a",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-11-07T03:32:55.471526Z",
     "iopub.status.busy": "2022-11-07T03:32:55.470269Z",
     "iopub.status.idle": "2022-11-07T03:32:55.479904Z",
     "shell.execute_reply": "2022-11-07T03:32:55.478632Z"
    },
    "papermill": {
     "duration": 0.024139,
     "end_time": "2022-11-07T03:32:55.481966",
     "exception": false,
     "start_time": "2022-11-07T03:32:55.457827",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# visits <- c()\n",
    "# hits <- c()\n",
    "# page_views <- c()\n",
    "# bounces <- c()\n",
    "# total_transaction_revenue <- c()\n",
    "# new_visits <- c()\n",
    "# session_quality_dim <- c()\n",
    "# transaction_revenue <- c()\n",
    "\n",
    "\n",
    "# for(i in totals_info) {\n",
    "#     if(length(i) == 6)\n",
    "#     visits <- append(visits, i$visits)\n",
    "#     hits <- append(hits, i$hits)\n",
    "#     page_views <- append(page_views, i$pageViews)\n",
    "#     bounces <- append(bounces, i$bounces)\n",
    "#     if(length(i$totalTransactionRevenue))\n",
    "#         total_transaction_revenue <- append(total_transaction_revenue, i$totalTransactionRevenue)\n",
    "#     else\n",
    "#         total_transaction_revenue <- append(total_transaction_revenue, 0)\n",
    "#     new_visits <- append(new_visits, i$newVisits)\n",
    "#     session_quality_dim <- append(session_quality_dim, i$sessionQualityDim)\n",
    "#     transaction_revenue <- append(transaction_revenue, i$transactionRevenue)\n",
    "# }\n",
    "\n",
    "# data['total_visits'] <- visits\n",
    "# data['total_hits'] <- hits\n",
    "# data['total_page_views'] <- page_views\n",
    "# data['total_total_transaction_revenue'] <- total_transaction_revenue\n",
    "# data['total_bounces'] <- bounces\n",
    "# data['total_new_visits'] <- new_visits\n",
    "# data['total_session_quality_dim'] <- session_quality_dim\n",
    "# data['total_transaction_revenue'] <- transaction_revenue"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "c2706e7c",
   "metadata": {
    "papermill": {
     "duration": 0.004378,
     "end_time": "2022-11-07T03:32:55.490763",
     "exception": false,
     "start_time": "2022-11-07T03:32:55.486385",
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
   "duration": 15.77555,
   "end_time": "2022-11-07T03:32:55.624404",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-11-07T03:32:39.848854",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
