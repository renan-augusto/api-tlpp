#include 'Totvs.CH'
#include 'topconn.ch'

/*/{Protheus.doc} setConfig
/*/
User Function setConfig

    local cTab      := 'MEU_TESTE'
    local oJson     := JsonObject():new() 
    local oJInt     := JsonObject():new()
    local cJson     := ''
    local lRpC      := .F.
    local aExte     := {}

    IF type('cEmpAnt') <> 'C'
        rpcSetEnv('99','01')
        lRPC := .T.
    EndIF


    oJInt['rotina'      ] := 'Teste'
    oJInt['extensions'  ] :=  {'.jpg', '.png'}
    oJInt['path'        ] := '/files/'

    oJson['minhaRotina' ] := oJInt

    cJson := oJson:toJson()

    begin transaction

        dbSelectArea('ZRM')
        dbSetOrder(1)

        if reclock('ZRM', .T.)
            
            ZRM_CONF := cJson
            ZRM_ROTN := cTab

        else 

            disarmTransaction()

        endif

        dbCloseArea()
    end transaction

Return .T.

/*/{Protheus.doc} updConfig
/*/
User Function updConfig

    local oJson     := jsonObject():new()
    local oInt     := jsonObject():new()
    local cJson     := ''
    local lRpc      := .F.
    local rotcon     := 'MEU_TESTE'
    
    IF type('cEmpAnt') <> 'C'
        rpcSetEnv('99','01')
        lRPC := .T.
    EndIF

    oInt['extensions'   ]   := {'.racm'}
    oInt['path'         ]   := '/files_/'      

    begin transaction

        dbSelectArea('ZRM')
        dbSetOrder(1)
        dbSeek(xFilial('ZRM') + rotcon)

        cJson := ZRM_CONF

        oJson:fromJson(cJson)

        oJson['minhaRotina']['extensions'] := oInt['extensions'   ]
        oJson['minhaRotina']['path'      ] := oInt['path'         ]

        cJson := oJson:toJson()

        if reclock('ZRM', .F.)

            ZRM_CONF := cJson
        
        else 

            disarmTransaction()
            return .F.

        endif
    
    end transaction
     

Return .T.
