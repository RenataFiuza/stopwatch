# Cronômetro MVVM (Flutter)

Aplicativo de cronômetro de voltas desenvolvido para atividade acadêmica. Implementa padrão **MVVM**, recursos de **acessibilidade** (Semantics, rótulos, tamanhos legíveis) e **notificações** (notificação persistente ao iniciar, notificação por volta, sugestão se pausado >10s).

## Funcionalidades
- Iniciar / pausar / resetar cronômetro
- Registrar voltas (exibe tempo da volta + tempo total)
- Notificação persistente enquanto cronômetro está ativo
- Notificação a cada volta registrada
- Notificação sugerindo retomar se pausado por mais de 10 segundos
- Acessibilidade com `Semantics` e atenção a contraste/fontes

## Pacotes usados
- provider
- flutter_local_notifications
- intl

## Como rodar
1. Clone o repositório:
```bash
git clone https://github.com/SEU_USUARIO/stopwatch_mvvm_flutter.git
cd stopwatch_mvvm_flutter
```
2. Instale dependências:
```bash
flutter pub get
```
3. Execute no emulador ou dispositivo:
```bash
flutter run
```

## Screenshot
![App em execução](assets/screenshots/screenshot1.png)

## Vídeo (demonstração)
- Link do vídeo: https://youtu.be/SEU_VIDEO

## LICENSE
Licenciado sob MIT — ver `LICENSE.md`.
