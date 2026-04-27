# Case Marketing — Análise de Performance de Campanhas

## Contexto
Análise de performance de campanhas de mídia paga em três plataformas digitais — Meta, YouTube e Spotify.
O objetivo foi identificar quais campanhas entregam resultado real, quais estão desperdiçando budget e como redistribuir o investimento para maximizar retorno.

## Pergunta de Negócio
> "Gastamos R$ 141.700 em campanhas no Meta, YouTube e Spotify. Onde está indo dinheiro fora e como redistribuir o orçamento para aumentar conversões e reduzir o CAC?"

## Ferramentas
- MySQL — extração e análise dos dados
- Power BI — visualização e dashboard

## Links
- 📊 [Portfólio no Notion](https://www.notion.so/Case-Marketing-3408f115aff580cdb207da8d9e8d8cb6)
- 💻 [Repositório GitHub](https://github.com/lucassdolci/Case-Marketing)


## Estrutura do Projeto
- `data/` — dataset simulado de campanhas (18 linhas × 9 colunas)
- `queries/` — análises em SQL organizadas por tema
- `dashboard/` — arquivo Power BI
- `docs/` — insights e recomendações

## Dashboard

### Visão Geral — KPIs Consolidados
![Visão Geral](dashboard/prints/01_visao_geral.png)
ROAS consolidado de 3,71x com CAC médio de R$44. Meta lidera em receita gerada com R$27Mi no período analisado.

### Performance por Plataforma — ROAS e CAC
![Performance](dashboard/prints/02_performance_plataforma.png)
Meta apresenta o melhor ROAS (4,7x) e menor CAC (R$33). Spotify surpreende com ROAS competitivo (3,0x) mesmo com menor investimento. YouTube tem o CAC mais alto do portfólio (R$56).

### Campanhas Ruins — Ranking por ROAS
![Campanhas](dashboard/prints/03_campanhas_ruins.png)
3 campanhas com ROAS abaixo de 1,5x consomem 20% do budget sem retorno adequado. YouTube Bumper Branding tem o pior desempenho com ROAS de 0,8x.

## Análises Realizadas

| Arquivo | Descrição |
| --- | --- |
| 01_queries_geral_analise | Visão geral consolidada de todas as campanhas |
| 02_receita_investimento_por_plataforma | Receita e investimento agrupados por plataforma |
| 03_cac_por_campanha | Custo de aquisição de cliente por campanha |
| 04_roas_por_campanha | Retorno sobre investimento por campanha |
| 05_ctr_por_campanha | Taxa de cliques por campanha e plataforma |
| 06_ranking_campanhas_ruins | Score de ineficiência e recomendação de corte |
