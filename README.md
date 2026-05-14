# Case Marketing — Análise de Performance de Campanhas

## Contexto

Queria trabalhar com dados de marketing pago porque é um problema concreto, toda empresa com campanhas rodando precisa saber onde o dinheiro está sendo bem gasto e onde não está.

Peguei Meta, YouTube e Spotify e fui direto: qual plataforma entrega mais retorno pelo que investe?

## Pergunta de Negócio

"Quais campanhas de Meta, YouTube e Spotify entregam melhor retorno sobre investimento, e como redistribuir o orçamento para maximizar conversões e reduzir o CAC?"

## Ferramentas

MySQL: extração e análise dos dados

Power BI: visualização e dashboard

## O que os dados mostraram

Meta performou bem, ROAS de 4,7x e o menor CAC do portfólio (R$33). Esperado.

YouTube decepcionou mais do que eu esperava. As campanhas Bumper chegaram a ROAS de 0,8x, cada R$1 investido retornou R$0,80. Três campanhas sozinhas consumindo 20% do budget sem retorno real.

O Spotify foi a surpresa. Podcast Ads com ROAS de 4,6x, quase igual ao Meta, mesmo sendo uma plataforma que costuma ter entrega naturalmente mais baixa. Potencial claro sendo ignorado.

## Estrutura do Projeto

data/ — dataset simulado de campanhas
queries/ — análises em SQL organizadas por tema
dashboard/ — arquivo Power BI
docs/ — insights e recomendações

## Dashboard

### Visão Geral — KPIs Consolidados
![Visão Geral](01_visao_geral.png)
ROAS consolidado de 3,71x. CAC médio de R$44. Meta lidera em receita.

### Performance por Plataforma — ROAS e CAC
![Performance](02_performance_plataforma.png)
Meta: melhor ROAS (4,7x) e menor CAC (R$33). Spotify surpreende com ROAS de 3,0x com menos investimento. YouTube: CAC mais alto (R$56).

### Campanhas Ruins — Ranking por ROAS
![Campanhas](03_campanhas_ruins.png)
3 campanhas com ROAS abaixo de 1,5x. YouTube Bumper Branding: 0,8x.

## Recomendações

Cortar as 3 campanhas com ROAS abaixo de 1,5x e realocar o budget para remarketing Meta, que já provou retorno, e escalar Podcast Ads no Spotify, que entrega ROAS de 4,6x sendo subexplorado. Para o YouTube, estudar onde está o gargalo antes de investir mais.

## Análises Realizadas

| Arquivo | Descrição |
|---|---|
| 01_queries_geral_analise | Visão geral consolidada |
| 02_receita_investimento_por_plataforma | Receita e investimento por plataforma |
| 03_cac_por_campanha | CAC por campanha |
| 04_roas_por_campanha | ROAS por campanha |
| 05_ctr_por_campanha | CTR por campanha e plataforma |
| 06_ranking_campanhas_ruins | Score de ineficiência e recomendação de corte |

## Links

📊 Portfólio no Notion: https://www.notion.so/Case-Marketing-3408f115aff580cdb207da8d9e8d8cb6
💻 Repositório GitHub: https://github.com/lucassdolci/Case-Marketing
