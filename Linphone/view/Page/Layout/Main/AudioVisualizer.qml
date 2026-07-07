import QtQuick
import QtQuick.Layouts
import Linphone
import "qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js" as Utils

// Live Audio Visualizer - ambient waveform animation
// Displays smoothly animated bars that simulate an audio equalizer
// Designed to be visible on light backgrounds (Calls page right panel)

Item {
    id: visualizer
    implicitWidth: contentColumn.implicitWidth
    implicitHeight: contentColumn.implicitHeight

    property int barCount: 48
    property real barWidth: Utils.getSizeWithScreenRatio(3)
    property real barSpacing: Utils.getSizeWithScreenRatio(2)
    property real maxBarHeight: Utils.getSizeWithScreenRatio(80)
    property real minBarHeight: Utils.getSizeWithScreenRatio(4)
    property color barColor: DefaultStyle.main2_500
    property real barOpacity: 0.45

    ColumnLayout {
        id: contentColumn
        anchors.centerIn: parent
        spacing: Utils.getSizeWithScreenRatio(16)

        Row {
            id: barRow
            Layout.alignment: Qt.AlignHCenter
            spacing: visualizer.barSpacing

            Repeater {
                model: visualizer.barCount

                Rectangle {
                    id: bar
                    width: visualizer.barWidth
                    height: visualizer.minBarHeight
                    radius: width / 2
                    color: visualizer.barColor
                    opacity: visualizer.barOpacity
                    anchors.verticalCenter: parent.verticalCenter

                    // Gradient-like effect: bars near edges are more transparent
                    Component.onCompleted: {
                        // Create a natural wave pattern - bars near center are taller
                        var centerDistance = Math.abs(index - visualizer.barCount / 2) / (visualizer.barCount / 2);
                        var heightFactor = 1.0 - (centerDistance * 0.65);

                        barAnimation.maxH = visualizer.maxBarHeight * heightFactor;
                        barAnimation.minH = visualizer.minBarHeight;

                        // Edge bars are more transparent for a fade-out effect
                        bar.opacity = visualizer.barOpacity * (1.0 - centerDistance * 0.5);

                        // Stagger start times and durations for organic feel
                        barAnimation.dur1 = 800 + Math.random() * 1200;
                        barAnimation.dur2 = 600 + Math.random() * 1000;
                        barAnimation.dur3 = 700 + Math.random() * 900;
                        barAnimation.dur4 = 500 + Math.random() * 800;

                        // Random intermediate heights
                        barAnimation.mid1 = visualizer.minBarHeight + (barAnimation.maxH - visualizer.minBarHeight) * (0.3 + Math.random() * 0.7);
                        barAnimation.mid2 = visualizer.minBarHeight + (barAnimation.maxH - visualizer.minBarHeight) * (0.1 + Math.random() * 0.4);
                        barAnimation.mid3 = visualizer.minBarHeight + (barAnimation.maxH - visualizer.minBarHeight) * (0.5 + Math.random() * 0.5);

                        // Delay start based on position for a wave sweep effect
                        startDelay.duration = index * 30;
                        startDelay.start();
                    }

                    PauseAnimation {
                        id: startDelay
                        onFinished: barAnimation.start()
                    }

                    SequentialAnimation {
                        id: barAnimation
                        loops: Animation.Infinite

                        property real maxH: visualizer.maxBarHeight
                        property real minH: visualizer.minBarHeight
                        property real mid1: visualizer.maxBarHeight * 0.5
                        property real mid2: visualizer.maxBarHeight * 0.3
                        property real mid3: visualizer.maxBarHeight * 0.7
                        property int dur1: 1000
                        property int dur2: 800
                        property int dur3: 900
                        property int dur4: 700

                        NumberAnimation {
                            target: bar; property: "height"
                            to: barAnimation.mid1
                            duration: barAnimation.dur1
                            easing.type: Easing.InOutSine
                        }
                        NumberAnimation {
                            target: bar; property: "height"
                            to: barAnimation.mid2
                            duration: barAnimation.dur2
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: bar; property: "height"
                            to: barAnimation.maxH
                            duration: barAnimation.dur3
                            easing.type: Easing.InOutSine
                        }
                        NumberAnimation {
                            target: bar; property: "height"
                            to: barAnimation.minH
                            duration: barAnimation.dur4
                            easing.type: Easing.InOutCubic
                        }
                    }
                }
            }
        }

        // Subtle label under the visualizer
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Z p h o n e"
            color: DefaultStyle.main2_400
            font.pixelSize: Utils.getSizeWithScreenRatio(14)
            font.weight: Font.Medium
            font.letterSpacing: Utils.getSizeWithScreenRatio(4)
            opacity: 0.6
        }
    }
}
