SETS
    IMPACTa0 "IMPACT Sectors in the file Data_IMPACT " /
        pdri
        pdrn
        whti
        whtn
        groi
        gron
        v_fi
        v_fn
        osdi
        osdn
        c_bi
        c_bn
        pfbi
        pfbn
        ocri
        ocrn
        ctl
        oap
        rmk
        vol
        sgr
    /

    IMPACTi0   "IMPACT commodities in the file Data_IMPACT " /
        ctl
        oap
        rmk
        vol
        sgr
        pdr
        wht
        gro
        v_f
        osd
        c_b
        pfb
        ocr
    /

    map_IMPACTa0i0(IMPACTa0,IMPACTi0)  /
        (pdri,pdrn).pdr
        (whti,whtn).wht
        (groi,gron).gro
        (v_fi,v_fn).v_f
        (osdi,osdn).osd
        (c_bi,c_bn).c_b
        (pfbi,pfbn).pfb
        (ocri,ocrn).ocr

        ctl.ctl
        oap.oap
        rmk.rmk
        vol.vol
        sgr.sgr
    /
;
