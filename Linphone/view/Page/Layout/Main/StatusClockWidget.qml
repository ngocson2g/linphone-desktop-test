import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import Linphone
import UtilsCpp
import "qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js" as Utils

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true

    property AccountProxy accounts: AccountProxy {}
    property AccountGui defaultAccount: accounts.defaultAccount

    property int missedCalls: defaultAccount && defaultAccount.core ? defaultAccount.core.unreadCallNotifications : 0
    property int unreadMessages: defaultAccount && defaultAccount.core ? defaultAccount.core.unreadMessageNotifications : 0
    property int presence: defaultAccount && defaultAccount.core ? defaultAccount.core.presence : LinphoneEnums.Presence.Offline

    // Greeting based on time of day
    property string greeting: {
        var hour = new Date().getHours();
        if (hour < 12) return "Good Morning";
        else if (hour < 18) return "Good Afternoon";
        else return "Good Evening";
    }

    // Daily tips rotation
    property var tips: [
        "💡 Press Ctrl+D to quickly dial a number.",
        "💡 You can import contacts from a CSV file.",
        "💡 Drag and drop files to share them in a chat.",
        "💡 Use the search bar to find contacts quickly.",
        "💡 Right-click a contact to see more options.",
        "💡 Your calls are encrypted end-to-end.",
        "💡 Set your presence status to let others know you're available."
    ]
    property int tipIndex: Math.floor(Math.random() * tips.length)

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var date = new Date();
            timeText.text = Qt.formatTime(date, "hh:mm");
            dateText.text = date.toLocaleDateString(Qt.locale(), Locale.LongFormat);
            // Update greeting if hour changes
            var hour = date.getHours();
            if (hour < 12) root.greeting = "Good Morning";
            else if (hour < 18) root.greeting = "Good Afternoon";
            else root.greeting = "Good Evening";
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Utils.getSizeWithScreenRatio(12)

        // Greeting text
        Text {
            id: greetingText
            Layout.alignment: Qt.AlignHCenter
            text: root.greeting + " 👋"
            color: DefaultStyle.main2_400
            font.pixelSize: Utils.getSizeWithScreenRatio(20)
            font.weight: Font.Normal

            // Fade-in animation
            opacity: 0
            Component.onCompleted: fadeIn.start()
            NumberAnimation on opacity {
                id: fadeIn
                from: 0; to: 1
                duration: 800
                easing.type: Easing.OutCubic
            }
        }

        // Clock
        Text {
            id: timeText
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatTime(new Date(), "hh:mm")
            color: DefaultStyle.main2_700
            font.pixelSize: Utils.getSizeWithScreenRatio(90)
            font.weight: Font.Light
        }

        // Date
        Text {
            id: dateText
            Layout.alignment: Qt.AlignHCenter
            text: new Date().toLocaleDateString(Qt.locale(), Locale.LongFormat)
            color: DefaultStyle.main2_400
            font.pixelSize: Typography.h3.pixelSize
            font.weight: Typography.h3.weight
        }

        Item { Layout.preferredHeight: Utils.getSizeWithScreenRatio(8) }

        // Presence status
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Utils.getSizeWithScreenRatio(10)
            Image {
                id: presenceIcon
                source: UtilsCpp.getPresenceIcon(root.presence)
                Layout.preferredWidth: Utils.getSizeWithScreenRatio(24)
                Layout.preferredHeight: Utils.getSizeWithScreenRatio(24)
                sourceSize.width: Utils.getSizeWithScreenRatio(48)
                sourceSize.height: Utils.getSizeWithScreenRatio(48)
                fillMode: Image.PreserveAspectFit
                smooth: true
                antialiasing: true
            }
            Text {
                text: UtilsCpp.getPresenceStatus(root.presence)
                color: UtilsCpp.getPresenceColor(root.presence)
                font.pixelSize: Typography.h4.pixelSize
                font.weight: Typography.h4.weight
            }
        }

        // Notification summary
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (root.missedCalls > 0 && root.unreadMessages > 0)
                    return qsTr("You have %1 missed calls and %2 unread messages.").arg(root.missedCalls).arg(root.unreadMessages);
                else if (root.missedCalls > 0)
                    return qsTr("You have %1 missed calls.").arg(root.missedCalls);
                else if (root.unreadMessages > 0)
                    return qsTr("You have %1 unread messages.").arg(root.unreadMessages);
                else
                    return qsTr("You have no new notifications.");
            }
            color: DefaultStyle.main2_500
            font.pixelSize: Typography.p1.pixelSize
            font.weight: Typography.p1.weight
        }

        Item { Layout.preferredHeight: Utils.getSizeWithScreenRatio(20) }


        // Daily Tip Card
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Utils.getSizeWithScreenRatio(370)
            Layout.preferredHeight: tipText.implicitHeight + Utils.getSizeWithScreenRatio(28)
            radius: Utils.getSizeWithScreenRatio(12)
            color: "#F0F9FF"
            border.width: 1
            border.color: "#BAE6FD"

            // Fade-in
            opacity: 0
            Component.onCompleted: tipFadeIn.start()
            SequentialAnimation {
                id: tipFadeIn
                PauseAnimation { duration: 500 }
                NumberAnimation { target: parent; property: "opacity"; from: 0; to: 1; duration: 600; easing.type: Easing.OutCubic }
            }

            Text {
                id: tipText
                anchors.centerIn: parent
                width: parent.width - Utils.getSizeWithScreenRatio(28)
                text: root.tips[root.tipIndex]
                color: "#0369A1"
                font.pixelSize: Utils.getSizeWithScreenRatio(13)
                font.weight: Font.Normal
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
