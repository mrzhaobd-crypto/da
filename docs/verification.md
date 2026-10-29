# 검증 기록 · 2026-10-29

- Flutter 3.47.5 / Dart 3.13.4, macOS arm64.
- `flutter pub get`: 성공.
- `flutter analyze`: No issues found.
- `flutter test`: 6개 통과, 2개 skip. Skip은 글꼴 환경변수가 있을 때만 실행하는 캡처 테스트다.
- 캡처 테스트: `EVIDENCE_FONT`와 `EVIDENCE_ICONS`를 지정해 별도 실행했고 2개 통과. 390px 상태 화면과 1280px 넓은 화면을 생성했다.
- `flutter build web --release`: 성공.
- GitHub 원격 `main`에서 새 경로로 clone한 뒤 `flutter pub get`, `flutter analyze`, `flutter test`, `flutter build web --release`를 다시 실행해 모두 성공했다.
- 테스트 범위: 입력 오류 해제, 3문항 전체 흐름, E 화면의 원래 보기·내 선택, 고정 결과, 세 GET 화면의 로딩·빈·오류·재시도, 320px·1280px 오버플로.
- 넓은 화면 자료: 1280×800에서 측면 안내와 3열 요약이 보이는 위젯 테스트 렌더링.
- 피쉬본: `docs/screenshots/fishbone.png` 1800×1000 생성, `docs/기획.md`에 삽입.
- 이전 브라우저 캡처는 유지하지만, 코드 수정 후 실제 브라우저 전체 흐름은 제출 전에 한 번 더 확인한다.
- 1분 영상은 브라우저 캡처 편집 + 명시한 위젯 테스트 상태 화면이다. 연속 녹화가 아니다.
- 발표자료는 27장으로 점검한 뒤 저장소에서 제외하고 LMS에 별도 제출한다. 발표자 노트와 슬라이드 10·11·12·13·14·15·16·27을 확인했다.
- 네이티브 플랫폼 빌드, 6분 실제 시간 측정, LMS 제출은 아직 확인하지 않았다.
