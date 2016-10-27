import React, {StyleSheet, Dimensions, PixelRatio} from "react-native";
const {width, height, scale} = Dimensions.get("window"),
    vw = width / 100,
    vh = height / 100,
    vmin = Math.min(vw, vh),
    vmax = Math.max(vw, vh);

export default StyleSheet.create({
    "admin-content": {
        "marginTop": "0% !important",
        "marginRight": "5%",
        "marginBottom": 0,
        "marginLeft": "5%",
        "height": "88%",
        "borderRadius": 5,
        "border": "1px solid rgb(88, 102, 124)",
        "paddingTop": 30,
        "paddingRight": 0,
        "paddingBottom": 30,
        "paddingLeft": 30,
        "backgroundColor": "rgb(88, 102, 124)"
    },
    "admin-content-h2": {
        "color": "#FFFFFF !important"
    },
    "admin-content-menu": {
        "float": "left"
    },
    "admin-content-left": {
        "marginTop": 20,
        "borderRightWidth": 1,
        "borderRight": "1px solid rgb(78, 92, 114)"
    },
    "admin-content-menu ul li a:hover": {
        "backgroundColor": "rgb(88, 102, 124) !important",
        "color": "#FFFFFF"
    },
    "admin-content-body": {
        "float": "left",
        "marginTop": 0,
        "marginRight": "auto",
        "marginBottom": 0,
        "marginLeft": 30,
        "width": "75%",
        "height": "100%",
        "backgroundColor": "rgb(78, 92, 114)",
        "borderRadius": 1
    },
    "slds-breadcrumb__item a": {
        "color": "#FFFFFF"
    },
    "slds-breadcrumb__item a:hover": {
        "color": "rgb(38, 45, 58)"
    }
});