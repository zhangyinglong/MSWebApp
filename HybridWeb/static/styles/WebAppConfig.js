import React, {StyleSheet, Dimensions, PixelRatio} from "react-native";
const {width, height, scale} = Dimensions.get("window"),
    vw = width / 100,
    vh = height / 100,
    vmin = Math.min(vw, vh),
    vmax = Math.max(vw, vh);

export default StyleSheet.create({
    "wac-content": {
        "paddingTop": 20,
        "paddingBottom": 20
    },
    "wac-content-table": {
        "backgroundColor": "rgb(78, 92, 114)"
    },
    "wac-content-table-head": {
        "color": "#FFFFFF"
    },
    "wac-content-table-cell": {
        "fontFamily": "sans-serif, \"Hiragino Sans GB W3\", \"Helvetica Neue\", \"Segoe UI\", Tahoma, Arial, \"Microsoft Yahei\", STHeiti",
        "fontSize": 14,
        "color": "#FFFFFF",
        "fontWeight": "normal"
    },
    "wac-content-button": {
        "backgroundColor": "rgb(78, 92, 114)",
        "color": "#FFFFFF"
    }
});