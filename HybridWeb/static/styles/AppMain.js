import React, {StyleSheet, Dimensions, PixelRatio} from "react-native";
const {width, height, scale} = Dimensions.get("window"),
    vw = width / 100,
    vh = height / 100,
    vmin = Math.min(vw, vh),
    vmax = Math.max(vw, vh);

export default StyleSheet.create({
    "content": {
        "paddingLeft": 0,
        "paddingRight": 0,
        "height": "90%"
    },
    "left-title": {
        "fontFamily": "sans-serif, \"Hiragino Sans GB W3\", \"Helvetica Neue\", \"Segoe UI\", Tahoma, Arial, \"Microsoft Yahei\", STHeiti",
        "fontSize": 36,
        "color": "#FFFFFF",
        "fontWeight": "200",
        "lineHeight": 36
    },
    "text-left": {
        "fontFamily": "sans-serif, \"Hiragino Sans GB W3\", \"Helvetica Neue\", \"Segoe UI\", Tahoma, Arial, \"Microsoft Yahei\", STHeiti",
        "fontSize": 24,
        "color": "rgb(48, 197, 156)",
        "fontWeight": "200"
    },
    "text-right": {
        "fontFamily": "sans-serif, \"Hiragino Sans GB W3\", \"Helvetica Neue\", \"Segoe UI\", Tahoma, Arial, \"Microsoft Yahei\", STHeiti",
        "fontSize": 24,
        "color": "#FFFFFF",
        "fontWeight": "200"
    },
    "left a": {
        "marginTop": 20,
        "display": "block",
        "width": 120,
        "height": 40,
        "borderRadius": 19,
        "border": "1px solid white",
        "color": "white",
        "textAlign": "center",
        "fontSize": 14,
        "fontFamily": "sans-serif, \"Hiragino Sans GB W3\", \"Helvetica Neue\", \"Segoe UI\", Tahoma, Arial, \"Microsoft Yahei\", STHeiti",
        "paddingTop": 13,
        "lineHeight": 12,
        "textDecoration": "none"
    },
    "left a:hover": {
        "color": "rgb(48, 197, 156)",
        "textDecoration": "none",
        "borderColor": "rgb(48, 197, 156)"
    },
    "left-detail": {
        "marginTop": 20
    },
    "left": {
        "position": "relative",
        "top": "35%",
        "marginLeft": "12%",
        "float": "left"
    },
    "right img": {
        "height": 407,
        "width": 550
    },
    "right": {
        "float": "left",
        "marginLeft": "12%",
        "marginTop": "8%"
    }
});