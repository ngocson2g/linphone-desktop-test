import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as Control
import Linphone
import ConstantsCpp
import SettingsCpp
import 'qrc:/qt/qml/Linphone/view/Control/Tool/Helper/utils.js' as Utils
import 'qrc:/qt/qml/Linphone/view/Style/buttonStyle.js' as ButtonStyle
import "qrc:/qt/qml/Linphone/view/Control/Button/"


LoginLayout {
	id: mainItem
	signal goBack()
	signal goToRegister()
	property bool showBackButton: false

	backgroundColor: "#FFFFFF"
	showMountains: false



	titleContent: [
		RowLayout {
			Layout.leftMargin: Utils.getSizeWithScreenRatio(119)
			spacing: Utils.getSizeWithScreenRatio(21)
			Button {
				id: backButton
				visible: mainItem.showBackButton 
				Layout.preferredHeight: Utils.getSizeWithScreenRatio(24)
				Layout.preferredWidth: Utils.getSizeWithScreenRatio(24)
				icon.source: AppIcons.leftArrow
				style: ButtonStyle.noBackground
				onClicked: { mainItem.goBack() }
			}
			ColumnLayout {
				spacing: 2
				Text {
					text: "Add new SIP account"
					color: DefaultStyle.grey_900
					font {
						pixelSize: Typography.h1.pixelSize
						weight: Typography.h1.weight
					}
					scaleLettersFactor: 1.1
				}
				Text {
					textFormat: Text.RichText
					text: "don't have, take one from <a href='https://voip.com.vn/document/getsipacc.html' style='color:#00AFF0;text-decoration:none;'><font color='orange'>Z</font>LINK</a>"
					color: DefaultStyle.grey_900
					font {
						pixelSize: Typography.p1.pixelSize
						weight: Typography.p1.weight
					}
					onLinkActivated: function(link) { Qt.openUrlExternally(link) }
				}
			}
		},
		Item {
			Layout.fillWidth: true
		},
		RowLayout {
			visible: false // Hidden by user request
			Layout.rightMargin: Utils.getSizeWithScreenRatio(51)
			spacing: Utils.getSizeWithScreenRatio(20)
			BigButton {
				Layout.alignment: Qt.AlignRight
				text: qsTr("Login")
				style: ButtonStyle.main
				onClicked: { mainItem.goToRegister() }
			}
		}
	]
	
	Component {
		id: firstItem
		Flickable {
			width: Utils.getSizeWithScreenRatio(361)
			contentWidth: content.implicitWidth
			contentHeight: content.implicitHeight
			clip: true
			flickableDirection: Flickable.VerticalFlick

			Control.ScrollBar.vertical: scrollbar

			ColumnLayout {
				id: content
				width: parent.width - scrollbar.width*2
				spacing: Utils.getSizeWithScreenRatio(85)
				ColumnLayout {
					spacing: 0
					ColumnLayout {
						spacing: Utils.getSizeWithScreenRatio(28)
						Text {
							Layout.fillWidth: true
							wrapMode: Text.WordWrap
							color: DefaultStyle.grey_900
							font {
								pixelSize: Typography.p1.pixelSize
								weight: Typography.p1.weight
							}
							text: qsTr("Certaines fonctionnalités telles que les conversations de groupe, les vidéo-conférences, etc… nécessitent un compte %1.\n\nCes fonctionnalités seront masquées si vous utilisez un compte SIP tiers.\n\nPour les activer dans un projet commercial, merci de nous contacter.").arg(applicationName)
						}
					}
					SmallButton {
						id: openLinkButton
						Layout.alignment: Qt.AlignCenter
						Layout.topMargin: Utils.getSizeWithScreenRatio(18)
						text: "voip.com.vn/contact"
						style: ButtonStyle.secondary
						onClicked: { Qt.openUrlExternally(ConstantsCpp.ContactUrl) }
					}
				}
				ColumnLayout {
					spacing: Utils.getSizeWithScreenRatio(20)
					BigButton {
						id: createAccountButton
						style: ButtonStyle.secondary
						Layout.fillWidth: true
						text: qsTr("assistant_third_party_sip_account_create_linphone_account")
						onClicked: { mainItem.goToRegister() }
					}
					BigButton {
						id: continueButton
						Layout.fillWidth: true
						text: qsTr("assistant_third_party_sip_account_warning_ok")
						style: ButtonStyle.main
						onClicked: { rootStackView.replace(secondItem) }
					}
				}
				Item { Layout.fillHeight: true }
			}
		}
	}
	
	Component {
		id: secondItem
		Flickable {
			id: formFlickable
			width: Utils.getSizeWithScreenRatio(770)
			contentWidth: contentForm.implicitWidth
			contentHeight: contentForm.implicitHeight
			clip: true
			flickableDirection: Flickable.VerticalFlick

			Control.ScrollBar.vertical: scrollbar

			RowLayout {
				id: contentForm
				width: formFlickable.width - scrollbar.width*2
				spacing: Utils.getSizeWithScreenRatio(50)
				ColumnLayout {
					spacing: Utils.getSizeWithScreenRatio(2)
					Layout.preferredWidth: Utils.getSizeWithScreenRatio(360)
					Layout.fillHeight: true
					ColumnLayout {
						spacing: Utils.getSizeWithScreenRatio(22)
						ColumnLayout {
							spacing: Utils.getSizeWithScreenRatio(10)
							FormItemLayout {
								id: displayName
								label: "<font color='#333333'>" + qsTr("sip_address_display_name") + "</font>"
								Layout.fillWidth: true
								contentItem: TextField {
									id: displayNameEdit
									width: parent.width
									KeyNavigation.down: usernameEdit
								}
							}
							FormItemLayout {
								id: username
								label: "<font color='#333333'>" + qsTr("username") + "</font>"
								mandatory: true
								enableErrorText: true
								Layout.fillWidth: true
								contentItem: TextField {
									id: usernameEdit
									isError: username.errorTextVisible || (LoginPageCpp.badIds && errorText.isVisible)
									width: parent.width
									KeyNavigation.up: displayNameEdit
									KeyNavigation.down: passwordEdit
								}
							}
							FormItemLayout {
								id: password
								label: "<font color='#333333'>" + qsTr("password") + "</font>"
								mandatory: true
								enableErrorText: true
								Layout.fillWidth: true
								contentItem: TextField {
									id: passwordEdit
									isError: password.errorTextVisible || (LoginPageCpp.badIds && errorText.isVisible)
									hidden: true
									width: parent.width
									KeyNavigation.up: usernameEdit
									KeyNavigation.down: connectionIdEdit
								}
							}
							FormItemLayout {
								id: connectionId
								label: "<font color='#333333'>" + qsTr("login_id") + "</font>"
								Layout.fillWidth: true
								contentItem: TextField {
									id: connectionIdEdit
									width: parent.width
									KeyNavigation.up: passwordEdit
									KeyNavigation.down: domainEdit
								}
							}
							FormItemLayout {
								id: domain
								label: "<font color='#333333'>" + qsTr("sip_address_domain") + "</font>"
								tooltip: qsTr("sip_address_domain_tooltip")
								mandatory: true
								enableErrorText: true
								Layout.fillWidth: true
								contentItem: TextField {
									id: domainEdit
									placeholderText: "sip.example.com"
									isError: domain.errorTextVisible
									initialText: SettingsCpp.assistantThirdPartySipAccountDomain
									width: parent.width
									KeyNavigation.up: connectionIdEdit
								}
								Connections {
									target: SettingsCpp
									function onAssistantThirdPartySipAccountDomainChanged() {
										domainEdit.resetText()
									}
								}
							}
							
							// Hidden fields to keep API compatible
							ComboBox {
								id: transportCbox
								visible: false
								textRole: "text"
								valueRole: "value"
								model: [
									{text: "TCP", value: LinphoneEnums.TransportType.Tcp},
									{text: "UDP", value: LinphoneEnums.TransportType.Udp},
									{text: "TLS", value: LinphoneEnums.TransportType.Tls},
									{text: "DTLS", value: LinphoneEnums.TransportType.Dtls}
								]
								currentIndex: 1
							}
							TextField {
								id: registrarUriEdit
								visible: false
								text: ""
							}
						}
					}

					TemporaryText {
						id: errorText
						Layout.fillWidth: true
						Connections {
							target: LoginPageCpp
							function onErrorMessageChanged(error) {
								errorText.setText(error)
							}
						}
					}

					BigButton {
						id: connectionButton
						Layout.topMargin: Utils.getSizeWithScreenRatio(15)
						style: ButtonStyle.main
						property Item tabTarget
						contentItem: StackLayout {
							id: connectionButtonContent
							currentIndex: 0
							Text {
								text: qsTr("Login")
								horizontalAlignment: Text.AlignHCenter
								verticalAlignment: Text.AlignVCenter
								font {
									pixelSize: Typography.b1.pixelSize
									weight: Typography.b1.weight
								}
								color: DefaultStyle.grey_0
							}
							BusyIndicator {
								implicitWidth: parent.height
								implicitHeight: parent.height
								Layout.alignment: Qt.AlignCenter
								indicatorColor: DefaultStyle.grey_0
								indicatorWidth: Utils.getSizeWithScreenRatio(25)
							}
							Connections {
								target: LoginPageCpp
								function onRegistrationStateChanged() {
									if (LoginPageCpp.registrationState != LinphoneEnums.RegistrationState.Progress) {
										connectionButton.enabled = true
										connectionButtonContent.currentIndex = 0
									}
								}
								function onErrorMessageChanged(error) {
									if (error.length != 0) {
										connectionButton.enabled = true
										connectionButtonContent.currentIndex = 0
									}
								}
							}
						}

						function trigger() {
							username.errorMessage = ""
							password.errorMessage = ""
							domain.errorMessage = ""
							errorText.clear()

							loginDelay.restart()
						}
						onPressed: trigger()
						Timer{
							id: loginDelay
							interval: 200
							onTriggered: {
								if (usernameEdit.text.length == 0 || passwordEdit.text.length == 0 || domainEdit.text.length == 0) {
									if (usernameEdit.text.length == 0)
										username.errorMessage = qsTr("assistant_account_login_missing_username")
									if (passwordEdit.text.length == 0)
										password.errorMessage = qsTr("assistant_account_login_missing_password")
									if (domainEdit.text.length == 0)
										domain.errorMessage = qsTr("assistant_account_login_missing_domain")
									return
								}
								
								var outProxy = "";
								if (outboundProxyRadio.checked) {
									outProxy = outboundProxyUriEdit.text;
								}
								
								// Set registrarUri empty if we want to register with domain
								var regUri = "";
								if (!registerDomainCheckBox.checked) {
									// In linphone, if registrarUri is empty, it registers to domain.
									// Without C++ changes, we can't easily disable registration entirely here,
									// but we can pass empty string to keep the default behavior as close as possible.
									regUri = "sip:dummy_do_not_register@localhost"; // A hack if we want to break registration? No, keep it empty.
								} else if (outProxy !== "") {
									// If proxy is set, use it as registrar URI to avoid DNS resolution of the fake domain
									regUri = outProxy;
								}

								console.debug("[SIPLoginPage] User: Log in, regUri:", regUri, "outProxy:", outProxy)
								LoginPageCpp.login(usernameEdit.text, passwordEdit.text, displayNameEdit.text, domainEdit.text, 
								transportCbox.currentValue, regUri, outProxy, connectionIdEdit.text);
								connectionButton.enabled = false
								connectionButtonContent.currentIndex = 1
							}
						}
					}
					
					Item {
						Layout.fillHeight: true
					}
				}
				ColumnLayout {
					Layout.preferredWidth: Utils.getSizeWithScreenRatio(360)
					Layout.fillHeight: true
					spacing: Utils.getSizeWithScreenRatio(22)
					
					ColumnLayout {
						spacing: Utils.getSizeWithScreenRatio(15)
						
						RowLayout {
							spacing: Utils.getSizeWithScreenRatio(10)
							CheckBox {
								id: registerDomainCheckBox
								checked: true
							}
							Text {
								text: "Register with domain and receive incoming calls"
								color: DefaultStyle.grey_900
								font {
									pixelSize: Typography.p1.pixelSize
								}
								MouseArea {
									anchors.fill: parent
									onClicked: registerDomainCheckBox.toggle()
								}
							}
						}

						Text {
							text: "Send outbound via:"
							color: DefaultStyle.grey_900
							font {
								pixelSize: Typography.p1.pixelSize
							}
							Layout.topMargin: Utils.getSizeWithScreenRatio(20)
						}
						
						RowLayout {
							spacing: Utils.getSizeWithScreenRatio(10)
							RadioButton {
								id: domainOutboundRadio
								checked: true
								onClicked: {
									domainOutboundRadio.checked = true
									outboundProxyRadio.checked = false
									targetDomainOutboundRadio.checked = false
								}
							}
							Text {
								text: "domain"
								color: DefaultStyle.grey_900
								font {
									pixelSize: Typography.p1.pixelSize
								}
								MouseArea {
									anchors.fill: parent
									onClicked: domainOutboundRadio.clicked()
								}
							}
						}

						RowLayout {
							spacing: Utils.getSizeWithScreenRatio(10)
							RadioButton {
								id: outboundProxyRadio
								checked: false
								onClicked: {
									outboundProxyRadio.checked = true
									domainOutboundRadio.checked = false
									targetDomainOutboundRadio.checked = false
								}
							}
							Text {
								text: "proxy Address"
								color: DefaultStyle.grey_900
								font {
									pixelSize: Typography.p1.pixelSize
								}
								MouseArea {
									anchors.fill: parent
									onClicked: outboundProxyRadio.clicked()
								}
							}
							
							TextField {
								id: outboundProxyUriEdit
								visible: outboundProxyRadio.checked
								Layout.preferredWidth: Utils.getSizeWithScreenRatio(200)
								placeholderText: "sip:proxy.com"
							}
						}
						
						RowLayout {
							spacing: Utils.getSizeWithScreenRatio(10)
							RadioButton {
								id: targetDomainOutboundRadio
								checked: false
								onClicked: {
									targetDomainOutboundRadio.checked = true
									domainOutboundRadio.checked = false
									outboundProxyRadio.checked = false
								}
							}
							Text {
								text: "target domain"
								color: DefaultStyle.grey_900
								font {
									pixelSize: Typography.p1.pixelSize
								}
								MouseArea {
									anchors.fill: parent
									onClicked: targetDomainOutboundRadio.clicked()
								}
							}
						}
						
					}
					Item{Layout.fillHeight: true}
				}
				Item{Layout.fillHeight: true}
			}
		}
	}

	centerContent: [
		ScrollBar {
			id: scrollbar
			z: 1
			active: true
			interactive: true
			parent: rootStackView.currentItem
			visible: parent.contentHeight > parent.height
			policy: Control.ScrollBar.AsNeeded
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.right: parent.right
		},
		Control.StackView {
			id: rootStackView
			initialItem: secondItem // Always skip the Linphone warning page and go straight to the form
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			anchors.leftMargin: Utils.getSizeWithScreenRatio(127)
			width: currentItem ? currentItem.width : 0
		}
	]
}
