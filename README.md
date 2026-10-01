# Good Habits: Acompanhamento de Hábitos ✅ 

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-Local-003B57?logo=sqlite)](https://www.sqlite.org)
[![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod-6A5AE0)](https://riverpod.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android)](https://developer.android.com)

## Visão Geral

O Good Habits é um aplicativo mobile em Flutter para controlar hábitos diários.

A aplicação acompanha 7 hábitos fundamentais: leitura, atividade física, meditação, controle do tempo de tela, dormir no horário, estudo e consumo de água. Os registros ficam salvos localmente no dispositivo e podem ser acompanhados por visão semanal, mensal e indicadores de sequência (streaks).

> O projeto foi pensado para uso offline, com experiência ágil e foco em consistência de rotina.

## Funcionalidades

- Checklist diário com marcação por toque único.
- Acompanhamento de 7 hábitos principais em um único painel.
- Toggle para marcar e desmarcar atividades no mesmo dia.
- Persistência local com SQLite.
- Organização por data local, evitando inconsistências de fuso horário.
- Visualização semanal de desempenho e taxa de conclusão.
- Relatórios mensais com calendário/heatmap de consistência.
- Indicadores de sequência de dias consecutivos.
- Interface em Material 3 com suporte a tema claro e escuro.
- Experiência 100% offline, sem login ou integração externa.

## Requisitos

- Sistema operacional compatível com desenvolvimento Flutter: Windows, macOS ou Linux.
- Flutter SDK 3.x com Dart 3.x.
- Android Studio ou Android SDK configurado.
- JDK 17 para o ambiente Android.
- Dispositivo Android físico ou emulador para execução local.
- Dependências declaradas em `pubspec.yaml`.

## Estrutura do Projeto

```text
good_habits/
├── android/                 # Configuração nativa do Android
├── assets/
│   └── icons/               # Ícones e recursos visuais do app
├── lib/
│   ├── core/
│   │   ├── database/        # Persistência local e acesso ao banco
│   │   ├── theme/           # Temas e estilos do Material 3
│   │   └── utils/           # Utilidades gerais, datas e helpers
│   ├── features/
│   │   ├── navigation/      # Estrutura da navegação principal
│   │   ├── reports/         # Relatórios, métricas e gráficos
│   │   └── tracker/         # Tela de hábitos e marcação diária
│   └── main.dart            # Ponto de entrada da aplicação
├── test/                    # Testes automatizados
├── analysis_options.yaml    # Regras do Dart/Flutter
├── pubspec.yaml             # Dependências do projeto
├── README.md                # Documentação do projeto
├── .gitignore
├── good_habits.iml
└── android.iml
```

## Instalação

1. Clone o repositório:

```bash
git clone https://github.com/seu-usuario/good_habits.git
cd good_habits
```

2. Instale as dependências do Flutter:

```bash
flutter pub get
```

3. Verifique o ambiente de desenvolvimento Android:

```bash
flutter doctor
```

4. Se necessário, configure o Android Studio ou emulador antes de executar o app.

## Como Executar

Conecte um dispositivo Android ou inicie um emulador e execute:

```bash
flutter devices
flutter run
```

Para gerar um arquivo APK de teste:

```bash
flutter build apk
```

## Fluxo de Uso

1. A aplicação abre diretamente para a tela principal de hábitos.
2. O usuário seleciona o dia desejado e visualiza os hábitos disponíveis.
3. Cada hábito pode ser marcado ou desmarcado com um único toque.
4. O registro é salvo localmente no banco de dados do app.
5. A interface exibe indicadores de consistência, taxa de conclusão e sequências.
6. O usuário pode acompanhar a evolução semanal e mensal do comportamento.

## Configuração

- O app utiliza armazenamento local em SQLite para persistir os registros.
- Não há variáveis de ambiente, chaves de API ou serviços externos obrigatórios.
- O tema pode seguir o sistema operacional, com suporte a modo claro e escuro.

## Testes

Execute a suíte de testes com:

```bash
flutter test
```

Também é recomendável validar a análise estática do código:

```bash
flutter analyze
```