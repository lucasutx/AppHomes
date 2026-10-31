# Home's Pizzaria

Aplicativo Flutter da Home's Pizzaria, com cardápio, orçamento em PDF e
controle de despesas por categoria.

## Armazenamento financeiro

Entradas de eventos e despesas são armazenadas na coleção `lancamentos` do
Cloud Firestore, no projeto `pizzaria-85c83`.

Não há tela de login. O aplicativo abre uma sessão anônima automática apenas
para autorizar o Firestore. Android e Web usam a configuração gerada em
`lib/firebase_options.dart`.

O dashboard apresenta entradas, despesas, saldo e gastos por categoria.
