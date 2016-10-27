import React, {StyleSheet, Dimensions, PixelRatio} from "react-native";
const {width, height, scale} = Dimensions.get("window"),
    vw = width / 100,
    vh = height / 100,
    vmin = Math.min(vw, vh),
    vmax = Math.max(vw, vh);

export default StyleSheet.create({
    "srv-content": {
        "paddingTop": 20,
        "paddingBottom": 20,
        "paddingRight": 30,
        "paddingLeft": 30
    },
    "srv-content p": {
        "color": "#FFFFFF",
        "fontFamily": "sans-serif, \"Hiragino Sans GB W3\", \"Helvetica Neue\", \"Segoe UI\", Tahoma, Arial, \"Microsoft Yahei\", STHeiti",
        "fontSize": 24,
        "textDecoration": "none",
        "marginBottom": 10
    },
    "srv-content-tip": {
        "color": "#FFFFFF"
    },
    "srv-content-form-ele": {
        "marginBottom": 10
    },
    "srv-content a": {
        "marginTop": 0,
        "marginRight": "auto",
        "marginBottom": 0,
        "marginLeft": "auto",
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
    "srv-content a:hover": {
        "color": "rgb(48, 197, 156)",
        "textDecoration": "none",
        "borderColor": "rgb(48, 197, 156)"
    }
});