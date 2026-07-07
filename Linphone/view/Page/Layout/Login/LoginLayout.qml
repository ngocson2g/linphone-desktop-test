/**
* Qml template used for welcome and login/register pages
**/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control

import Linphone
import ConstantsCpp
import QtQuick.Effects
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
				ctx.arc(node.x, node.y, 3, 0, 2 * Math.PI);
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
						var opacity = (1.0 - (dist / maxDistance)) * 0.5;
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

            property int currentDesignOption: 2

            Timer {
                id: autoSwapTimer
                interval: 5000 // Swap every 5 seconds
                running: true
                repeat: true
                onTriggered: {
                    centerLayout.currentDesignOption = (centerLayout.currentDesignOption + 1) % 3;
                }
            }

			GlassmorphismFeatureCard {
                id: option1Container
				visible: centerLayout.currentDesignOption === 0
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -Utils.getSizeWithScreenRatio(80)
				anchors.right: parent.right
				anchors.rightMargin: Utils.getSizeWithScreenRatio(150)
			}

            Item {
                id: premiumIllustrationContainer
                visible: centerLayout.currentDesignOption === 1
                anchors.verticalCenter: parent.verticalCenter
				anchors.right: parent.right
				anchors.rightMargin: Utils.getSizeWithScreenRatio(100)
				width: Utils.getSizeWithScreenRatio(450)
				height: Utils.getSizeWithScreenRatio(450)

                SequentialAnimation on anchors.verticalCenterOffset {
                    loops: Animation.Infinite
                    NumberAnimation { to: -15; duration: 4000; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 15; duration: 4000; easing.type: Easing.InOutSine }
                }

                Rectangle {
                    id: imageMask
                    anchors.centerIn: parent
                    width: parent.width * 0.95
                    height: parent.height * 0.95
                    radius: width / 2
                    color: "black"
                    visible: false
                    // Soft edges
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blurMax: 64
                        blur: 1.0
                    }
                }

                Image {
                    id: premiumIllustration
                    anchors.fill: parent
                    source: AppIcons.loginIllustration
                    fillMode: Image.PreserveAspectFit
                    visible: false
                }

                ShaderEffect {
                    anchors.fill: parent
                    property var source: ShaderEffectSource { sourceItem: premiumIllustration }
                    property var maskSource: ShaderEffectSource { sourceItem: imageMask }
                    fragmentShader: 'qrc:/data/shaders/opacityMask.frag.qsb'
                }
            }

            // OPTION 3: Artistic Gradient Text
            Item {
                id: option3Container
                visible: centerLayout.currentDesignOption === 2

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Utils.getSizeWithScreenRatio(150)
                width: option3Col.width
                height: option3Col.height

                SequentialAnimation on anchors.verticalCenterOffset {
                    loops: Animation.Infinite
                    NumberAnimation { to: -10; duration: 5000; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 10; duration: 5000; easing.type: Easing.InOutQuad }
                }

                ColumnLayout {
                    id: option3Col
                    spacing: Utils.getSizeWithScreenRatio(20)

                    Item {
                        Layout.preferredWidth: textMask.width
                        Layout.preferredHeight: textMask.height
                        Layout.alignment: Qt.AlignRight

                        Rectangle {
                            id: gradientRect
                            width: textMask.width
                            height: textMask.height
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: "#00C6FF" } // Light Cyan
                                GradientStop { position: 1.0; color: "#0072FF" } // Deep Blue
                            }
                            visible: false
                        }

                        Text {
                            id: textMask
                            text: "WELCOME\nTO ZPHONE"
                            font.pixelSize: Utils.getSizeWithScreenRatio(70)
                            font.weight: Font.Black
                            horizontalAlignment: Text.AlignRight
                            lineHeight: 0.9
                            visible: false
                        }

                        ShaderEffect {
                            width: gradientRect.width
                            height: gradientRect.height
                            property var source: ShaderEffectSource { sourceItem: gradientRect }
                            property var maskSource: ShaderEffectSource { sourceItem: textMask }
                            fragmentShader: 'qrc:/data/shaders/opacityMask.frag.qsb'
                        }
                    }

                    Text {
                        text: "Kết nối không giới hạn, vươn tầm cao mới."
                        color: DefaultStyle.grey_500
                        font.pixelSize: Typography.h3.pixelSize
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }

            // Design Option Switcher (Dot Pagination)
            Row {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Utils.getSizeWithScreenRatio(30)
                anchors.right: parent.right
                anchors.rightMargin: Utils.getSizeWithScreenRatio(150)
                spacing: Utils.getSizeWithScreenRatio(15)
                z: 10

                Repeater {
                    model: 3
                    Rectangle {
                        width: centerLayout.currentDesignOption === index ? Utils.getSizeWithScreenRatio(24) : Utils.getSizeWithScreenRatio(12)
                        height: Utils.getSizeWithScreenRatio(12)
                        radius: height / 2
                        color: centerLayout.currentDesignOption === index ? DefaultStyle.main2_500 : DefaultStyle.grey_300
                        
                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -Utils.getSizeWithScreenRatio(10) // Larger hit area
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                centerLayout.currentDesignOption = index;
                                autoSwapTimer.restart(); // Restart timer so it doesn't swap immediately after user clicks
                            }
                        }
                        
                        Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                        Behavior on color { ColorAnimation { duration: 250 } }
                    }
                }
            }
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
 
