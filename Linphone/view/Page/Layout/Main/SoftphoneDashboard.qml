import QtQuick
import QtQuick.Layouts
import QtQuick.Particles
import Linphone
import "qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js" as Utils
import "qrc:/qt/qml/Linphone/view/Style/buttonStyle.js" as ButtonStyle

Item {
    id: root
    implicitWidth: Utils.getSizeWithScreenRatio(600)
    implicitHeight: Utils.getSizeWithScreenRatio(600)

    signal requestNewCall()
    signal requestGroupCall()

    // Background Particles
    ParticleSystem {
        id: particleSystem
        anchors.fill: parent

        ItemParticle {
            id: particles
            system: particleSystem
            delegate: Rectangle {
                width: Utils.getSizeWithScreenRatio(Math.random() * 6 + 4)
                height: width
                radius: width / 2
                color: DefaultStyle.info_500_main
                opacity: 0.4
            }
        }

        Emitter {
            system: particleSystem
            anchors.fill: parent
            emitRate: 3
            lifeSpan: 12000
            lifeSpanVariation: 3000
            size: 10
            endSize: 0
            velocity: PointDirection { y: -10; yVariation: 10; xVariation: 15 }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Utils.getSizeWithScreenRatio(45)

        // Clock Widget (already contains Greeting, Clock, Date, Presence, Missed calls, Tips)
        StatusClockWidget {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Utils.getSizeWithScreenRatio(500)
            Layout.preferredHeight: Utils.getSizeWithScreenRatio(300)
        }

        // Quick Actions
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Utils.getSizeWithScreenRatio(30)

            BigButton {
                icon.source: AppIcons.newCall
                text: "New Call"
                style: ButtonStyle.main
                onPressed: root.requestNewCall()
            }
        }
    }
}
