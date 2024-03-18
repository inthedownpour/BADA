import 'package:flutter/material.dart';

class MyTermsWidget extends StatelessWidget {
  final String termsText = '''
제 1 조 (목적)
본 약관은 주식회사 카카오(이하 "회사")가 제공하는 사물위치정보 및 위치기반 서비스(이하, 위치정보 서비스)에 대해 회사와 서비스를 이용하는 이용자간의 권리·의무 및 책임사항, 기타 필요한 사항 규정을 목적으로 합니다.
제 2 조 (이용약관의 효력 및 변경)
①본 약관은 이용자가 본 약관에 동의하고 회사가 정한 절차에 따라 위치정보 서비스의 이용자로 등록됨으로써 효력이 발생합니다.
②이용자가 본 약관의 “동의하기” 버튼을 클릭하였을 경우 본 약관의 내용을 모두 읽고 이를 충분히 이해하였으며, 그 적용에 동의한 것으로 봅니다.
③회사는 위치정보 서비스의 변경사항을 반영하기 위한 목적 등으로 필요한 경우 관련 법령을 위배하지 않는 범위에서 본 약관을 수정할 수 있습니다.
④약관이 변경되는 경우 회사는 변경사항을 그 적용일자 최소 15일 전에 회사의 홈페이지 또는 서비스 공지사항 등(이하, 홈페이지 등)을 통해 공지합니다. 다만, 개정되는 내용이 이용자 권리의 중대한 변경을 발생시키는 경우 적용일 최소 30일 전에 이메일(이메일주소가 없는 경우 서비스 내 전자쪽지 발송, 서비스 내 알림 메시지를 띄우는 등의 별도의 전자적 수단) 발송 또는 등록한 휴대폰번호로 카카오톡 메시지 또는 문자메시지를 발송하는 방법 등으로 개별적으로 고지합니다.
⑤회사가 전항에 따라 공지 또는 통지를 하면서 공지 또는 통지일로부터 개정약관 시행일 7일 후까지 거부의사를 표시하지 아니하면 승인한 것으로 본다는 뜻을 명확하게 고지하였음에도 이용자의 의사표시가 없는 경우에는 변경된 약관을 승인한 것으로 봅니다. 이용자가 개정약관에 동의하지 않을 경우 본 약관에 대한 동의를 철회할 수 있습니다.
제 3 조 (약관 외 준칙)
이 약관에 명시되지 않은 사항에 대해서는 위치 정보의 보호 및 이용 등에 관한 법률, 개인정보보호법, 전기통신사업법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 관계법령 및 회사가 정한 지침 등의 규정에 따릅니다.
제 4 조 (서비스의 내용)
회사는 위치정보사업자로부터 수집한 이용자의 위치정보 또는 직접 수집한 사물위치정보를 이용하여 아래와 같은 위치정보 서비스를 제공합니다.
①위치정보를 활용한 정보 검색결과 및 콘텐츠를 제공하거나 추천
②생활편의를 위한 위치 공유, 위치/지역에 따른 알림, 경로 안내
③위치기반의 컨텐츠 분류를 위한 콘텐츠 태깅
④위치기반의 맞춤형 광고
제 5 조 (서비스 이용요금)
회사가 제공하는 위치정보 서비스는 무료입니다. 단, 무선 서비스 이용 시 발생하는 데이터 통신료는 별도이며, 이용자가 가입한 각 이동통신사의 정책에 따릅니다.
제 6 조 (서비스의 변경・제한・중지)
①회사는 정책변경 또는 관련법령 변경 등과 같은 제반 사정을 이유로 위치기반서비스를 유지할 수 없는 경우 위치기반서비스의 전부 또는 일부를 변경·제한·중지할 수 있습니다.
②회사는 아래 각호의 경우에는 이용자의 서비스 이용을 제한하거나 중지시킬 수 있습니다.
1.이용자가 회사 서비스의 운영을 고의 또는 중과실로 방해하는 경우
2.서비스용 설비 점검, 보수 또는 공사로 인하여 부득이한 경우
3.전기통신사업법에 규정된 기간통신사업자가 전기통신 서비스를 중지했을 경우
4.국가비상사태, 서비스 설비의 장애 또는 서비스 이용의 폭주 등으로 서비스 이용에 지장이 있는 때
5.기타 중대한 사유로 인하여 회사가 서비스 제공을 지속하는 것이 부적당하다고 인정하는 경우
③회사가 제1항 및 제2항의 규정에 의하여 서비스 이용을 제한하거나 중지한 때에는 그 사유 및 제한기간 등을 회사 홈페이지 등을 통해 사전 공지하거나 이용자에게 통지합니다.
제 7 조 (개인위치정보의 이용 또는 제공)
①회사는 개인위치정보를 이용하여 위치기반서비스를 제공하는 경우 본 약관에 고지하고 동의를 받습니다.
②회사는 이용자의 동의 없이 개인위치정보를 제3자에게 제공하지 않으며, 제3자에게 제공하는 경우에는 제공받는 자 및 제공목적을 사전에 이용자에게 고지하고 동의를 받습니다.
③제2항에 따라 개인위치정보를 이용자가 지정하는 제3자에게 제공하는 경우 개인위치정보를 수집한 통신단말장치 또는 전자우편주소로 매회 이용자에게 제공받는 자, 제공일시 및 제공목적을 즉시 통지합니다. 단, 아래의 경우 이용자가 미리 특정하여 지정한 통신단말장치 또는 전자우편주소, 온라인게시 등으로 통지합니다.
1.개인위치정보를 수집한 당해 통신단말장치가 문자, 음성 또는 영상의 수신기능을 갖추지 아니한 경우
2.이용자의 개인위치정보를 수집한 통신단말장치 외의 통신단말장치 또는 전자우편주소, 온라인게시 등으로 통보할 것을 미리 요청한 경우
④회사는 위치정보의 보호 및 이용 등에 관한 법률 제16조 제2항에 근거하여 위치정보 수집·이용·제공사실 확인자료를 자동으로 기록·보존하며, 해당 자료는 6개월간 보관합니다.
위치정보 제공 현황 자세히 보기
제 8 조 (개인위치정보의 보유 목적 및 보유기간)
회사는 위치기반서비스 제공을 위해 아래와 같이 개인위치정보를 보유합니다.
①본 약관 제4조 따른 위치기반서비스 이용 및 제공 목적 달성한 때에는 지체없이 개인위치정보를 파기합니다.
②다만, 이용자가 작성한 게시물 또는 콘텐츠와 함께 위치정보가 저장되는 서비스의 경우 해당 게시물 또는 콘텐츠의 보관기간 동안 개인위치정보가 보관됩니다.
③그 외 위치기반서비스 제공을 위해 필요한 경우 이용목적 달성을 위해 필요한 최소한의 기간 동안 개인위치정보를 보유할 수 있습니다.
④위 1, 2, 3항에도 불구하고 다른 법령 또는 위치정보법에 따라 보유해야하는 정당한 사유가 있는 경우에는 그에 따릅니다.
제 9 조 (개인위치정보주체의 권리)
①이용자는 언제든지 개인위치정보를 이용한 위치기반서비스의 이용 및 제공에 대한 동의 전부 또는 일부를 유보할 수 있습니다.
②이용자는 언제든지 개인위치정보를 이용한 위치기반서비스의 이용 및 제공에 대한 동의 전부 또는 일부를 철회할 수 있습니다. 이 경우 회사는 지체 없이 철회된 범위의 개인위치정보 및 위치정보 이용·제공사실 확인자료를 파기합니다.
③이용자는 개인위치정보의 이용·제공의 일시적인 중지를 요구할 수 있습니다. 이 경우 회사는 이를 거절할 수 없으며 이를 충족하는 기술적 수단을 마련합니다
④이용자는 회사에 대하여 아래 자료에 대한 열람 또는 고지를 요구할 수 있으며, 해당 자료에 오류가 있는 경우에는 정정을 요구할 수 있습니다. 이 경우 회사는 정당한 사유 없이 요구를 거절하지 않습니다.
1.이용자에 대한 위치정보 이용·제공사실 확인자료
2.이용자의 개인위치정보가 위치정보의 보호 및 이용 등에 관한 법률 또는 다른 법령의 규정에 의하여 제3자에게 제공된 이유 및 내용
⑤이용자는 권리행사를 위해 본 약관 제14조의 연락처를 이용하여 회사에 요청할 수 있습니다.
제 10 조 (법정대리인의 권리)
①회사는 14세 미만의 이용자에 대해서는 개인위치정보를 이용한 위치기반서비스 제공 및 개인위치정보의 제3자 제공에 대한 동의를 이용자 및 이용자의 법정대리인으로부터 받아야 합니다. 이 경우 법정대리인은 본 약관 제8조에 의한 이용자의 권리를 모두 가집니다.
②회사는 14세 미만의 아동의 개인위치정보 또는 위치정보 이용, 제공사실 확인자료를 이용약관에 명시 또는 고지한 범위를 넘어 이용하거나 제3자에게 제공하고자 하는 경우 이용자와 이용자의 법정대리인의 동의를 받아야 합니다. 단, 아래의 경우는 제외합니다.
1.위치정보 및 위치기반서비스 제공에 따른 요금정산을 위하여 위치정보 이용, 제공사실 확인자료가 필요한 경우
2.통계작성, 학술연구 또는 시장조사를 위하여 특정 개인을 알아볼 수 없는 형태로 가공하여 제공하는 경우
제 11 조 (8세 이하의 아동 등의 보호의무자의 권리)
①회사는 아래의 경우에 해당하는 자(이하 “8세 이하의 아동 등”)의 위치정보의 보호 및 이용 등에 관한 법률 제26조2항에 해당하는 자(이하 “보호의무자”)가 8세 이하의 아동 등의 생명 또는 신체보호를 위하여 개인위치정보의 이용 또는 제공에 동의하는 경우에는 본인의 동의가 있는 것으로 봅니다.
1.8세 이하의 아동
2.피성년후견인
3.장애인복지법 제2조제2항제2호에 따른 정신적 장애를 가진 사람으로서 장애인고용촉진 및 직업재활법 제2조제2호에 따른 중증장애인에 해당하는 사람(장애인복지법 제32조에 따라 장애인 등록을 한 사람만 해당한다)
②8세 이하의 아동 등의 생명 또는 신체의 보호를 위하여 개인위치정보의 이용 또는 제공에 동의를 하고자 하는 보호의무자는 서면동의서에 보호의무자임을 증명하는 서면을 첨부하여 회사에 제출하여야 합니다.
③보호의무자는 8세 이하의 아동 등의 개인위치정보 이용 또는 제공에 동의하는 경우 본 약관 제9조에 의한 이용자의 권리를 모두 가집니다.
제 12 조 (손해배상)
회사의 위치정보의 보호 및 이용 등에 관한 법률 제15조 및 26조의 규정을 위반한 행위로 인해 손해를 입은 경우 이용자는 회사에 손해배상을 청구할 수 있습니다. 회사는 고의, 과실이 없음을 입증하지 못하는 경우 책임을 면할 수 없습니다.
제 13 조 (면책)
①회사는 다음 각 호의 경우로 위치기반서비스를 제공할 수 없는 경우 이로 인하여 이용자에게 발생한 손해에 대해서는 책임을 부담하지 않습니다.
1.천재지변 또는 이에 준하는 불가항력의 상태가 있는 경우
2.위치기반서비스 제공을 위하여 회사와 서비스 제휴계약을 체결한 제3자의 고의적인 서비스 방해가 있는 경우
3.이용자의 귀책사유로 위치기반서비스 이용에 장애가 있는 경우
4.제1호 내지 제3호를 제외한 기타 회사의 고의·과실이 없는 사유로 인한 경우
②회사는 위치기반서비스 및 위치기반서비스에 게재된 정보, 자료, 사실의 신뢰도, 정확성 등에 대해서는 보증을 하지 않으며 이로 인해 발생한 이용자의 손해에 대하여는 책임을 부담하지 아니합니다.
제 14 조 (분쟁의 조정 및 기타)
①회사는 위치정보와 관련된 분쟁의 해결을 위해 이용자와 성실히 협의합니다.
②전항의 협의에서 분쟁이 해결되지 않은 경우, 회사와 이용자는 위치정보의 보호 및 이용 등에 관한 법률 제28조의 규정에 의해 방송통신위원회에 재정을 신청하거나, 개인정보보호법 제43조의 규정에 의해 개인정보 분쟁조정위원회에 조정을 신청할 수 있습니다.
제 15 조 (사업자 및 위치정보관리책임자 정보)
① 회사의 상호, 주소 및 연락처는 아래와 같습니다.
상호 : 주식회사 카카오
주소 : 제주특별자치도 제주시 첨단로 242 (영평동)
대표전화 : 1577-3754 (유료)
② 회사는 개인위치정보를 적절히 관리·보호하고, 이용자의 불만을 원활히 처리할 수 있도록 실질적인 책임을 질 수 있는 지위에 있는 자를 위치정보관리책임자로 지정해 운영하고 있습니다. 위치정보관리책임자는 위치기반서비스를 제공하거나 관리하는 부서의 부서장으로서 성명과 연락처는 아래와 같습니다.
성명 : 김연지
대표전화 : 1577-3754 (유료)
''';

  const MyTermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Text(termsText),
    );
  }
}
