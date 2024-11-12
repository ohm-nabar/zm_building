#define PLAYER_ENDONS(who)      who endon("disconnect"); \
                                who endon("bled_out");

// CSC oriented utils
#define DELETE_CSC_FX(local_client,fx_var) \
    if(IsDefined(fx_var)) { \
        DeleteFX(local_client, fx_var); \
        fx_var = undefined; \
    }

#define STOP_CSC_FX(local_client,fx_var) \
    if(IsDefined(fx_var)) { \
        StopFX(local_client, fx_var); \
        fx_var = undefined; \
    }

#define SET_UIMODEL(local_client,model,value)  SetUIModelValue(CreateUIModel(GetUIModelForController(local_client), model), value);