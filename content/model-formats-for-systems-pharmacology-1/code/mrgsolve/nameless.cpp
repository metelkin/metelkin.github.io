# Demo
```{r,echo=TRUE}
  ev(amt=10) %>% mrgsim %>% plot
```

$SET end=120, delta=0.1, hmax=0.01, hmin=0, rtol=1e-3, atol=1e-6

$PARAM
kabs_Alc : 0.1 
Vmax_ADH : 0.5 
Km_ADH : 0.1 
Vmax_ALDH : 0.5 
Km_ALDH : 0.1 
sw1_ : 1
sw2_ : 1

$CMT
Alc_g
Alc_b_amt_
AcHc_amt_

$GLOBAL
#define Alc_b (Alc_b_amt_ / blood)
#define AcHc (AcHc_amt_ / blood)

$PREAMBLE
double gut = 1.0;
double blood = 5.5;

$MAIN
Alc_g_0 = 0.0;
Alc_b_amt__0 = 0.0;
AcHc_amt__0 = 0.0;

$ODE
double vabs_Alc = kabs_Alc * Alc_g;
double v_ADH = Vmax_ADH * Alc_b / (Km_ADH + Alc_b) * blood;
double v_ALDH = Vmax_ALDH * AcHc / (Km_ALDH + AcHc) * blood;

dxdt_Alc_g = (-1)*vabs_Alc;
dxdt_Alc_b_amt_ = (1)*vabs_Alc + (-1)*v_ADH;
dxdt_AcHc_amt_ = (1)*v_ADH + (-1)*v_ALDH;
