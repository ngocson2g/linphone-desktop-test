import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Linphone
import "qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js" as Utils

Item {
    id: root
    width: Utils.getSizeWithScreenRatio(420)
    height: column.implicitHeight + Utils.getSizeWithScreenRatio(80)

    // A subtle slow breathing animation
    SequentialAnimation on scale {
        loops: Animation.Infinite
        NumberAnimation { to: 1.02; duration: 3000; easing.type: Easing.InOutSine }
        NumberAnimation { to: 1.0; duration: 3000; easing.type: Easing.InOutSine }
    }

    Rectangle {
        id: card
        anchors.fill: parent
        radius: Utils.getSizeWithScreenRatio(24)
        color: "#1500AFF0" // Very subtle blue tint
        border.color: "#3300AFF0"
        border.width: Utils.getSizeWithScreenRatio(1)

        MultiEffect {
            source: blurSource
            anchors.fill: parent
            autoPaddingEnabled: true
            blurEnabled: true
            blurMax: 64
            blur: 1.0
            visible: false // We use color instead if blur is too heavy, but actually MultiEffect requires a source Item.
        }
        
        // Since MultiEffect needs a source to blur the background behind it, which is complex in QML without a ShaderEffectSource or blurring a specific item,
        // we'll just use a translucent gradient which achieves the glass look without performance hit.
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#22FFFFFF" }
            GradientStop { position: 1.0; color: "#1100AFF0" }
        }

        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: Utils.getSizeWithScreenRatio(40)
            spacing: Utils.getSizeWithScreenRatio(25)

            // Logo or Icon
            Image {
                Layout.alignment: Qt.AlignHCenter
                source: AppIcons.splashscreenLogo
                Layout.preferredWidth: Utils.getSizeWithScreenRatio(120)
                Layout.preferredHeight: Utils.getSizeWithScreenRatio(120)
                fillMode: Image.PreserveAspectFit
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Welcome to Zphone"
                color: DefaultStyle.main2_700
                font.pixelSize: Typography.h1.pixelSize
                font.weight: Typography.h1.weight
            }

            Item { Layout.preferredHeight: Utils.getSizeWithScreenRatio(10) }

            // Features list
            component FeatureItem: RowLayout {
                property string iconSource
                property string title
                property string description
                spacing: Utils.getSizeWithScreenRatio(20)
                Rectangle {
                    Layout.preferredWidth: Utils.getSizeWithScreenRatio(48)
                    Layout.preferredHeight: Utils.getSizeWithScreenRatio(48)
                    radius: Utils.getSizeWithScreenRatio(24)
                    color: "#2200AFF0"
                    Image {
                        anchors.centerIn: parent
                        source: parent.parent.iconSource
                        width: Utils.getSizeWithScreenRatio(24)
                        height: Utils.getSizeWithScreenRatio(24)
                    }
                }
                ColumnLayout {
                    spacing: Utils.getSizeWithScreenRatio(4)
                    Text {
                        text: parent.parent.title
                        color: DefaultStyle.main2_700
                        font.pixelSize: Typography.h3.pixelSize
                        font.weight: Typography.h3.weight
                    }
                    Text {
                        text: parent.parent.description
                        color: DefaultStyle.main2_500
                        font.pixelSize: Typography.p1.pixelSize
                        font.weight: Typography.p1.weight
                    }
                }
            }

            FeatureItem {
                iconSource: AppIcons.lock
                title: "Bảo mật tuyệt đối"
                description: "Mã hóa SRTP/ZRTP."
            }
            FeatureItem {
                iconSource: AppIcons.videoCamera
                title: "Chất lượng HD"
                description: "Cuộc gọi thoại và video mượt mà."
            }
            FeatureItem {
                iconSource: AppIcons.desktop
                title: "Đa nền tảng"
                description: "Kết nối mọi lúc, mọi nơi."
            }
            
            Item { Layout.fillHeight: true }
        }
    }
}
