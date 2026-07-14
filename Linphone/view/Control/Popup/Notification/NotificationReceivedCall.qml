import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Linphone
import UtilsCpp
import 'qrc:/qt/qml/Linphone/view/Style/buttonStyle.js' as ButtonStyle
import "qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js" as Utils

// =============================================================================

Notification {
	id: mainItem
    radius: Utils.getSizeWithScreenRatio(10)
	backgroundColor: DefaultStyle.grey_600
	backgroundOpacity: 0.8
    overriddenWidth: Utils.getSizeWithScreenRatio(400)
	overriddenHeight: content.height
	
	readonly property var call: notificationData && notificationData.call
	readonly property var displayName: notificationData && notificationData.displayName
	property var contactObj: call ? UtilsCpp.findFriendByAddress(call.core.remoteAddress) : null
	property var contact: contactObj && contactObj.value || null
	property string noteText: contact ? contact.core.vcardNote : ""
	property var state: call.core.state
	property var status: call.core.status
	property var conference: call.core.conference

	onStateChanged:{
		if (state != LinphoneEnums.CallState.IncomingReceived){
			close()
		}
	}
	onStatusChanged:{
		console.log("status", status)
	}
	
	Popup {
		id: content
		visible: mainItem.visible
        leftPadding: Utils.getSizeWithScreenRatio(32)
        rightPadding: Utils.getSizeWithScreenRatio(32)
        topPadding: Utils.getSizeWithScreenRatio(9)
        bottomPadding: Utils.getSizeWithScreenRatio(18)
		anchors.centerIn: parent
		background: Item{}
		contentItem: ColumnLayout {
			anchors.verticalCenter: parent.verticalCenter
            spacing: Utils.getSizeWithScreenRatio(9)
			RowLayout {
                spacing: Utils.getSizeWithScreenRatio(4)
				Layout.alignment: Qt.AlignHCenter
				Image {
                    Layout.preferredWidth: Utils.getSizeWithScreenRatio(12)
                    Layout.preferredHeight: Utils.getSizeWithScreenRatio(12)
					source: AppIcons.logo
				}
				Text {
					text: "Linphone"
					color: DefaultStyle.grey_0
					font {
                        pixelSize: Utils.getSizeWithScreenRatio(12)
                        weight: Typography.b3.weight
						capitalization: Font.Capitalize
					}
				}
			}
			ColumnLayout {
                spacing: Utils.getSizeWithScreenRatio(17)
				ColumnLayout {
                    spacing: Utils.getSizeWithScreenRatio(14)
					Layout.alignment: Qt.AlignHCenter
					Avatar {
                        Layout.preferredWidth: Utils.getSizeWithScreenRatio(60)
                        Layout.preferredHeight: Utils.getSizeWithScreenRatio(60)
						Layout.alignment: Qt.AlignHCenter
						call: mainItem.call
						displayNameVal: mainItem.displayName
						secured: securityLevel === LinphoneEnums.SecurityLevel.EndToEndEncryptedAndVerified
						isConference: mainItem.call && mainItem.call.core.isConference
					}
					ColumnLayout {
						spacing: 0
						Text {
							text: displayName
							Layout.fillWidth: true
                            Layout.maximumWidth: mainItem.width - content.leftPadding - content.rightPadding
							Layout.alignment: Qt.AlignHCenter
							horizontalAlignment: Text.AlignHCenter
							maximumLineCount: 1
							color: DefaultStyle.grey_0
							font {
                                pixelSize: Utils.getSizeWithScreenRatio(20)
                                weight: Typography.b3.weight
								capitalization: Font.Capitalize
							}
						}
						Text {
                            //: "Appel entrant"
                            text: qsTr("call_audio_incoming")
							Layout.alignment: Qt.AlignHCenter
							color: DefaultStyle.grey_0
							font {
                                pixelSize: Utils.getSizeWithScreenRatio(14)
                                weight: Utils.getSizeWithScreenRatio(500)
							}
						}
					}
				}
				Rectangle {
					Layout.alignment: Qt.AlignHCenter
					Layout.preferredWidth: Math.min(parent.width - Utils.getSizeWithScreenRatio(40), Utils.getSizeWithScreenRatio(400))
					visible: mainItem.noteText.length > 0
					Layout.preferredHeight: Math.min(Utils.getSizeWithScreenRatio(150), noteTextItem.implicitHeight + Utils.getSizeWithScreenRatio(20))
					color: "#22000000" // Subtle dark background for the note
					radius: Utils.getSizeWithScreenRatio(10)
					clip: true
					
					ScrollView {
						anchors.fill: parent
						anchors.margins: Utils.getSizeWithScreenRatio(10)
						clip: true
						
						Text {
							id: noteTextItem
							width: parent.width
							text: "Note :\n" + mainItem.noteText
							wrapMode: Text.Wrap
							color: DefaultStyle.grey_0
							font {
								pixelSize: Typography.p1.pixelSize
								weight: Typography.p1.weight
							}
						}
					}
				}
				RowLayout {
					Layout.alignment: Qt.AlignHCenter
					Layout.fillWidth: true
                    spacing: Utils.getSizeWithScreenRatio(26)
					Button {
                        spacing: Utils.getSizeWithScreenRatio(6)
						style: ButtonStyle.phoneGreen
                        Layout.preferredWidth: Utils.getSizeWithScreenRatio(118)
                        Layout.preferredHeight: Utils.getSizeWithScreenRatio(32)
						asynchronous: false
                        icon.width: Utils.getSizeWithScreenRatio(19)
                        icon.height: Utils.getSizeWithScreenRatio(19)
                        //: "Accepter"
                        text: qsTr("dialog_accept")
                        textSize: Utils.getSizeWithScreenRatio(14)
                        textWeight: Utils.getSizeWithScreenRatio(500)
						onClicked: {
							console.debug("[NotificationReceivedCall] Accept click")
							UtilsCpp.openCallsWindow(mainItem.call)
							mainItem.call.core.lAccept(false)
						}
					}
					Button {
                        spacing: Utils.getSizeWithScreenRatio(6)
						style: ButtonStyle.phoneRed
                        Layout.preferredWidth: Utils.getSizeWithScreenRatio(118)
                        Layout.preferredHeight: Utils.getSizeWithScreenRatio(32)
						asynchronous: false
                        icon.width: Utils.getSizeWithScreenRatio(19)
                        icon.height: Utils.getSizeWithScreenRatio(19)
                        //: "Refuser
                        text: qsTr("dialog_deny")
                        textSize: Utils.getSizeWithScreenRatio(14)
                        textWeight: Utils.getSizeWithScreenRatio(500)
						onClicked: {
							console.debug("[NotificationReceivedCall] Decline click")
							mainItem.call.core.lDecline()
						}
					}
				}
			}
		}
	}

}
