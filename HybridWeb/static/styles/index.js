import React, {StyleSheet, Dimensions, PixelRatio} from "react-native";
const {width, height, scale} = Dimensions.get("window"),
    vw = width / 100,
    vh = height / 100,
    vmin = Math.min(vw, vh),
    vmax = Math.max(vw, vh);

export default StyleSheet.create({
    "html": {
        "height": "100%",
        "backgroundColor": "rgb(38, 45, 58)"
    },
    "body": {
        "width": "100%",
        "height": "100%",
        "backgroundColor": "rgb(38, 45, 58)"
    },
    "nav-bar": {
        "height": 100,
        "width": "100%",
        "marginTop": 0,
        "marginRight": "auto",
        "marginBottom": 0,
        "marginLeft": "auto",
        "paddingTop": 30,
        "paddingRight": 0,
        "paddingBottom": 30,
        "paddingLeft": 30,
        "position": "fixed",
        "top": 0,
        "background": "rgb(38, 45, 58)",
        "zIndex": 1
    },
    "nav-items": {
        "float": "right",
        "marginRight": 0
    },
    "nav-bar img": {
        "verticalAlign": "bottom"
    },
    "nav-bar ul": {
        "marginTop": 10,
        "marginRight": 70,
        "float": "right"
    },
    "nav-bar ul li": {
        "float": "right",
        "listStyle": "none",
        "marginRight": 18
    },
    "nav-bar ul li a": {
        "color": "#FFFFFF",
        "fontFamily": "sans-serif, \"Hiragino Sans GB W3\", \"Helvetica Neue\", \"Segoe UI\", Tahoma, Arial, \"Microsoft Yahei\", STHeiti",
        "fontSize": 14,
        "textDecoration": "none"
    },
    "nav-bar ul li a:hover": {
        "color": "rgb(48, 197, 156)"
    },
    "container": {
        "height": "100%",
        "marginTop": 100,
        "backgroundColor": "rgb(38, 45, 58)"
    }
});