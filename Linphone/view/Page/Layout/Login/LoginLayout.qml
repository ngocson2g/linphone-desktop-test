/**
* Qml template used for welcome and login/register pages
**/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control

import Linphone
import ConstantsCpp
import 'qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js' as Utils
import 'qrc:/qt/qml/Linphone/view/Style/buttonStyle.js' as ButtonStyle

Rectangle {
	id: mainItem
	property alias titleContent : titleLayout.children
	property alias centerContent : centerLayout.children
	property color backgroundColor: DefaultStyle.grey_0
	property bool showMountains: false
	color: backgroundColor

	Canvas {
		id: networkCanvas
		anchors.fill: parent

		property var nodes: []
		property int numNodes: 50
		property real maxDistance: Utils.getSizeWithScreenRatio(150)

		onPaint: {
			var ctx = getContext("2d");
			ctx.clearRect(0, 0, width, height);
			ctx.lineWidth = 1;
			for (var i = 0; i < numNodes; i++) {
				var node = nodes[i];
				node.x += node.vx;
				node.y += node.vy;
				if (node.x <= 0 || node.x >= width) node.vx *= -1;
				if (node.y <= 0 || node.y >= height) node.vy *= -1;
				
				ctx.beginPath();
				ctx.arc(node.x, node.y, 2, 0, 2 * Math.PI);
				ctx.fillStyle = "rgba(100, 150, 255, 0.6)";
				ctx.fill();
				
				for (var j = i + 1; j < numNodes; j++) {
					var otherNode = nodes[j];
					var dx = node.x - otherNode.x;
					var dy = node.y - otherNode.y;
					var dist = Math.sqrt(dx * dx + dy * dy);
					if (dist < maxDistance) {
						ctx.beginPath();
						ctx.moveTo(node.x, node.y);
						ctx.lineTo(otherNode.x, otherNode.y);
						var opacity = (1.0 - (dist / maxDistance)) * 0.4;
						ctx.strokeStyle = "rgba(100, 150, 255, " + opacity + ")";
						ctx.stroke();
					}
				}
			}
		}

		Component.onCompleted: {
			for (var i = 0; i < numNodes; i++) {
				nodes.push({
					x: Math.random() * 1000,
					y: Math.random() * 800,
					vx: (Math.random() - 0.5) * 1,
					vy: (Math.random() - 0.5) * 1
				});
			}
		}

		Timer {
			interval: 33
			running: true
			repeat: true
			onTriggered: networkCanvas.requestPaint()
		}
	}

	Rectangle {
		id: bottomGradientOverlay
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		height: parent.height / 3

		gradient: Gradient {
			GradientStop { position: 0.0; color: "transparent" }
			// ZLINK blue color for the bottom edge
			GradientStop { position: 1.0; color: "#00AFF0" } 
		}

		// Dynamic intensity (opacity) animation
		SequentialAnimation on opacity {
			loops: Animation.Infinite
			NumberAnimation { to: 0.7; duration: 2500; easing.type: Easing.InOutSine }
			NumberAnimation { to: 0.2; duration: 2500; easing.type: Easing.InOutSine }
		}
	}

	component AboutLine: RowLayout {
		id: line
        spacing: Utils.getSizeWithScreenRatio(20)
		property var imageSource
		property string title
		property string text
		property bool enableMouseArea: false
		signal contentClicked()
		EffectImage {
            Layout.preferredWidth: Utils.getSizeWithScreenRatio(32)
            Layout.preferredHeight: Utils.getSizeWithScreenRatio(32)
			imageSource: parent.imageSource
			colorizationColor: DefaultStyle.main1_500_main
		}
		ColumnLayout {
			spacing: 0
			Text {
				Layout.fillWidth: true
				text: line.title
				color: DefaultStyle.main2_600
				font {
                    pixelSize: Typography.b2.pixelSize
                    weight: Typography.b2.weight
				}
				horizontalAlignment: Layout.AlignLeft
			}
			Text {
				id: content
				Layout.fillWidth: true
				text: line.text
				color: DefaultStyle.main2_500_main
                font.pixelSize: Utils.getSizeWithScreenRatio(14)
				horizontalAlignment: Layout.AlignLeft
				Keys.onPressed: (event)=> {
					if (event.key == Qt.Key_Space || event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
						line.contentClicked(undefined)
						event.accepted = true;
					}
				}
				MouseArea {
					id: privateMouseArea
					enabled: line.enableMouseArea
					anchors.fill: parent
					hoverEnabled: true
					cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
					onClicked: line.contentClicked()
				}
			}
		}
		// Item {Layout.fillWidth: true}
	}

	Dialog {
		id: aboutPopup
		anchors.centerIn: parent
        width: Utils.getSizeWithScreenRatio(637)
        //: À propos de %1
        title: qsTr("help_about_title").arg(applicationName)
        bottomPadding: Utils.getSizeWithScreenRatio(10)
		buttons: []
		content: RowLayout {
			ColumnLayout {
                spacing: Utils.getSizeWithScreenRatio(17)
				Layout.alignment: Qt.AlignTop | Qt.AlignLeft
				AboutLine {
					imageSource: AppIcons.detective
                    //: "Politique de confidentialité"
                    title: qsTr("help_about_privacy_policy_title")
                    //: "Visiter notre potilique de confidentialité"
                    text: qsTr("help_about_privacy_policy_link")
					enableMouseArea: true
					onContentClicked: Qt.openUrlExternally(ConstantsCpp.PrivatePolicyUrl)
				}
				AboutLine {
					imageSource: AppIcons.info
                    //: "Version"
                    title: qsTr("help_about_version_title")
					text: Qt.application.version
				}
				AboutLine {
					imageSource: AppIcons.checkSquareOffset
                    //: "Licence"
                    title: qsTr("help_about_licence_title")
					text: applicationLicence
				}
				AboutLine {
					imageSource: AppIcons.copyright
                    //: "Copyright
                    title: qsTr("help_about_copyright_title")
					text: applicationVendor
				}
				Item {
					// Item to shift close button
                    Layout.preferredHeight: Utils.getSizeWithScreenRatio(10)
				}
			}
			MediumButton {
				Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                //: "Fermer"
                text: qsTr("close")
				style: ButtonStyle.main
				onClicked: aboutPopup.close()
			}
		}
	}

	ColumnLayout {
		anchors.fill: parent
        spacing: 0
        RowLayout {
			Layout.fillWidth: true
            Layout.topMargin: Math.max(Utils.getSizeWithScreenRatio(5), Utils.getSizeWithScreenRatio(25 - ((25/(DefaultStyle.defaultHeight - mainWindow.minimumHeight))*(DefaultStyle.defaultHeight-mainWindow.height))))
            Layout.rightMargin: Math.max(Utils.getSizeWithScreenRatio(5), Utils.getSizeWithScreenRatio(42 - ((42/(DefaultStyle.defaultWidth - mainWindow.minimumWidth))*(DefaultStyle.defaultWidth-mainWindow.width))))
			spacing: 0
			Item {
				Layout.fillWidth: true
			}
			BigButton {
				id: aboutButton
				Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
				icon.source: AppIcons.info
				text: qsTr("help_about_title").arg(applicationName)
				textSize: Typography.p1.pixelSize
				textWeight: Typography.p1.weight
				textColor: DefaultStyle.main2_500_main
				onClicked: aboutPopup.open()
				style: ButtonStyle.noBackground
			}
		}

		RowLayout {
			id: titleLayout
			Layout.fillWidth: true
            Layout.topMargin: Math.max(Utils.getSizeWithScreenRatio(10), Utils.getSizeWithScreenRatio(40 - ((40/(DefaultStyle.defaultHeight - mainWindow.minimumHeight))*(DefaultStyle.defaultHeight-mainWindow.height))))
			spacing: 0
		}
		Item {
			id: centerLayout
			Layout.fillHeight: true
			Layout.fillWidth: true
            Layout.topMargin: Math.max(Utils.getSizeWithScreenRatio(15), Utils.getSizeWithScreenRatio(70 - ((70/(DefaultStyle.defaultHeight - mainWindow.minimumHeight))*(DefaultStyle.defaultHeight-mainWindow.height))))
            Layout.alignment: Qt.AlignBottom

		}
		Image {
			id: bottomMountains
			visible: mainItem.showMountains
			source: AppIcons.belledonne
			fillMode: Image.Stretch
			Layout.fillWidth: true
            Layout.preferredHeight: Utils.getSizeWithScreenRatio(108)
		}
	}

} 
 
