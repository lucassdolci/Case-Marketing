# POWER BI — ESTRUTURA DO DASHBOARD
## Case: Análise de Performance de Campanhas de Marketing 2025

---

## ESQUEMA ESTRELA (Star Schema)

```
                    ┌─────────────────┐
                    │   dCalendario   │
                    │─────────────────│
                    │ data_id (PK)    │
                    │ mes_ano         │
                    │ mes_num         │
                    │ mes_nome        │
                    │ ano             │
                    │ trimestre       │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
┌─────────┴──────┐  ┌───────┴────────┐  ┌──────┴─────────┐
│  dPlataforma   │  │  fCampanhas    │  │   dCampanha    │
│────────────────│  │ (FATO)         │  │────────────────│
│ plataforma_id  │  │────────────────│  │ campanha_id    │
│ nome_plataforma│◄─┤ campanha_id FK │  │ nome_campanha  │
│ tipo_midia     │  │ plataforma_id  ├─►│ tipo_campanha  │
│ formato_padrao │  │ data_id     FK │  │ objetivo       │
│ benchmark_ctr  │  │ investimento   │  │ publico_alvo   │
└────────────────┘  │ impressoes     │  └────────────────┘
                    │ cliques        │
                    │ conversoes     │
                    │ receita_brl    │
                    └────────────────┘
```

---

## TABELAS DAX — MEDIDAS CALCULADAS

### Tabela: fCampanhas (Fato)
```
campanha_id       | FK → dCampanha
plataforma_id     | FK → dPlataforma
data_id           | FK → dCalendario
investimento_brl  | Decimal
impressoes        | Integer
cliques           | Integer
conversoes        | Integer
receita_gerada_brl| Decimal
```

### Tabela: dCalendario
```
data_id    | YYYYMM (ex: 202501)
mes_ano    | "Jan/2025"
mes_num    | 1
mes_nome   | "Janeiro"
ano        | 2025
trimestre  | "Q1 2025"
```

### Tabela: dPlataforma
```
plataforma_id     | 1=Meta, 2=YouTube, 3=Spotify
nome_plataforma   | "Meta"
tipo_midia        | "Social" / "Video" / "Audio"
formato_padrao    | "Feed/Stories" / "InStream" / "Audio/Display"
benchmark_ctr_pct | 0.90 / 0.65 / 0.25
cor_hex           | "#1877F2" / "#FF0000" / "#1DB954"
```

### Tabela: dCampanha
```
campanha_id    | C001–C018
nome_campanha  | Nome descritivo
tipo_campanha  | "Retargeting" / "Prospeccao" / "Branding"
objetivo       | "Conversao" / "Awareness" / "Consideracao"
publico_alvo   | "Quente" / "Frio" / "Morno"
```

---

## MEDIDAS DAX PRINCIPAIS

```dax
// KPI: ROAS total
ROAS = DIVIDE(SUM(fCampanhas[receita_gerada_brl]), SUM(fCampanhas[investimento_brl]))

// KPI: CAC médio ponderado
CAC = DIVIDE(SUM(fCampanhas[investimento_brl]), SUM(fCampanhas[conversoes]))

// KPI: CTR
CTR = DIVIDE(SUM(fCampanhas[cliques]), SUM(fCampanhas[impressoes])) * 100

// KPI: Taxa de Conversão
Taxa_Conversao = DIVIDE(SUM(fCampanhas[conversoes]), SUM(fCampanhas[cliques])) * 100

// KPI: ROI
ROI = DIVIDE(
    SUM(fCampanhas[receita_gerada_brl]) - SUM(fCampanhas[investimento_brl]),
    SUM(fCampanhas[investimento_brl])
) * 100

// Score de Ineficiência (para ranking de campanhas ruins)
Score_Ineficiencia =
    VAR roas_val = DIVIDE(SUM(fCampanhas[receita_gerada_brl]), SUM(fCampanhas[investimento_brl]))
    VAR cac_val  = DIVIDE(SUM(fCampanhas[investimento_brl]), SUM(fCampanhas[conversoes]))
    VAR ctr_val  = DIVIDE(SUM(fCampanhas[cliques]), SUM(fCampanhas[impressoes])) * 100
    RETURN
        IF(roas_val < 1.5, 3, IF(roas_val < 2.5, 1, 0)) +
        IF(cac_val  > 100, 3, IF(cac_val  > 60,  1, 0)) +
        IF(ctr_val  < 0.15, 2, 0)
```

---

## ESTRUTURA DAS 4 PÁGINAS

### PÁGINA 1 — Visão Geral
```
Layout: 2x2 KPI cards + gráfico de linha temporal + tabela resumo

KPI Cards:
  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
  │  ROAS    │  │   CAC    │  │   CTR    │  │  Conv.   │
  │  Total   │  │  Médio   │  │  Médio   │  │  Total   │
  │  3.48x   │  │  R$55    │  │  0.71%   │  │  2.885   │
  └──────────┘  └──────────┘  └──────────┘  └──────────┘

Gráfico: Receita vs Investimento por mês (barras agrupadas)
Tabela: Resumo por plataforma (todas as métricas)

Filtros: Plataforma | Mês | Tipo de Campanha
```

### PÁGINA 2 — Por Plataforma
```
Layout: Comparativo lado a lado com visuais individuais

Visuais:
  • Gráfico de radar: Meta vs YouTube vs Spotify
    (eixos: ROAS, CTR, Taxa Conv., Eficiência CAC, Volume)
  • Barras horizontais: Investimento por plataforma
  • Barras horizontais: Receita por plataforma
  • Scatter plot: Investimento x Receita (bolhas = conversões)
  • Tabela detalhada com todas as campanhas por plataforma

Destaque visual:
  Meta    → azul  (#1877F2)
  YouTube → vermelho (#FF0000)
  Spotify → verde (#1DB954)
```

### PÁGINA 3 — Campanhas
```
Layout: Ranking completo + destaque para campanhas ruins

Visuais:
  • Tabela ranking: todas campanhas ordenadas por ROAS
    Colunas: Nome | Plataforma | Mês | Investimento |
             Receita | ROAS | CAC | CTR | Status
  • Formatação condicional:
    - ROAS < 1.5: fundo vermelho
    - CAC > 100:  fundo laranja
    - CTR < 0.15: ícone de alerta
  • Gráfico de barras: ROAS por campanha (horizontal)
    Linha de referência: ROAS = 3.0 (benchmark)
  • Badge de recomendação:
    🔴 Corte | 🟡 Revisão | 🟠 Monitorar | 🟢 Manter
```

### PÁGINA 4 — Redistribuição de Orçamento
```
Layout: Análise de otimização + simulador de budget

Cenário Atual (Jan+Fev combinado):
  Meta:    R$ 48.200  →  34.5%
  YouTube: R$ 59.200  →  42.4%
  Spotify: R$ 34.300  →  24.6%

Orçamento Total: R$ 141.700

Cenário Otimizado (proposta):
  Meta:    R$ 63.765  →  45%  (+R$15.565 | +32%)
  YouTube: R$ 49.595  →  35%  (-R$ 9.605 | -16%)
  Spotify: R$ 28.340  →  20%  (-R$ 5.960 | -17%)

Campanhas para corte (economizar R$ 12.500+):
  ❌ Meta_Prospeccao_Novo_Publico  → ROAS 1.05
  ❌ YouTube_Bumper_Branding       → ROAS 0.73
  ❌ Spotify_Display_Retargeting   → ROAS 1.41

Projeção de resultado otimizado:
  • Conversões estimadas: +18% (+519 conversões/mês)
  • CAC projetado: -22% (de R$55 para R$43)
  • Receita projetada: +24% (de R$591.860 para R$733.906)

Visuais:
  • Gráfico de rosca: distribuição atual vs proposta
  • Tabela: campanhas cortadas + verba realocada
  • Waterfall chart: impacto da redistribuição na receita
  • Gauge: CAC atual vs CAC projetado
```

---

## RELACIONAMENTOS NO MODELO

```
fCampanhas[campanha_id]   → dCampanha[campanha_id]    (N:1)
fCampanhas[plataforma_id] → dPlataforma[plataforma_id] (N:1)
fCampanhas[data_id]       → dCalendario[data_id]       (N:1)
```

Filtros: Direção única (dDimensão → fFato)
Cross-filter: Desativado entre dimensões

---

## TEMAS E FORMATAÇÃO

Paleta principal:
  Primária:   #1E293B (slate-800)
  Acento 1:   #3B82F6 (blue-500)
  Sucesso:    #10B981 (emerald-500)
  Alerta:     #F59E0B (amber-500)
  Perigo:     #EF4444 (red-500)
  Fundo:      #F8FAFC (slate-50)
  Card:       #FFFFFF

Fontes: Segoe UI (nativa Power BI)
  Título página: 20px Bold
  KPI valor:     32px Bold
  KPI label:     12px Regular muted
  Tabela:        11px Regular
