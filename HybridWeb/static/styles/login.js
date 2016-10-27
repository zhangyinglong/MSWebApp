import React, {StyleSheet, Dimensions, PixelRatio} from "react-native";
const {width, height, scale} = Dimensions.get("window"),
    vw = width / 100,
    vh = height / 100,
    vmin = Math.min(vw, vh),
    vmax = Math.max(vw, vh);

export default StyleSheet.create({
    "slds-form--stacked": {
        "marginTop": "16% !important",
        "marginRight": "auto",
        "marginBottom": 0,
        "marginLeft": "auto",
        "width": 600,
        "borderRadius": 5,
        "border": "1px solid rgb(88, 102, 124)",
        "paddingTop": 30,
        "paddingRight": 50,
        "paddingBottom": 40,
        "paddingLeft": 50
    },
    "login-p": {
        "fontSize": 18,
        "color": "#FFFFFF"
    },
    "login-button": {
        "fontSize": "13px !important",
        "fontFamily": "sans-serif, \"Hiragino Sans GB W3\", \"Helvetica Neue\", \"Segoe UI\", Tahoma, Arial, \"Microsoft Yahei\", STHeiti !important",
        "fontWeight": "200",
        "width": "100%"
    }
});