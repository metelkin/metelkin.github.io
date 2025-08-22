function [ode_func, out_func, y0_, events_conditions, events_affects] = nameless_model(p)
    ode_func = @ODEFunc;
    out_func = @OutputFunc;
    events_conditions = @Conditions;

    vec = p(6:7) ~= 0;
    events_affects_full = {@sw1_affect, @sw2_affect};
    % reduce to number of active events
    events_affects = events_affects_full(vec);
    y0_ = InitFunc();

    % shared variable
    shared_values = zeros(1, 8);
    integrator = [];

    %%% Initialization of dynamic records
    function y__ = InitFunc()
        integrator = []; % reset integrator
        time = 0; % zero time
        
        Alc_g = 0; % Alc_g,  (mole)
        vabs_Alc = p(1) * Alc_g; % vabs_Alc,  ()
        Alc_b = 0; % Alc_b,  ()
        v_ADH = p(2) * Alc_b / (p(3) + Alc_b) * p(9); % v_ADH,  ()
        AcHc = 0; % AcHc,  ()
        v_ALDH = p(4) * AcHc / (p(5) + AcHc) * p(9); % v_ALDH,  ()

        % before reinitialization
        y0__ = [Alc_g; Alc_b * p(9); AcHc * p(9)];

        % reinitialization by events
        y__ = ReinitY0(time, y0__);
    end

    %%% Check events conditions at `zero`
    function y__ = ReinitY0(time, y0)
        
        % size is number of active events
        cond_zero = Conditions(time, y0);
        ev_idxs = find(cond_zero==0, 1);
        
        if ~isempty(ev_idxs)
            for idx = 1:length(ev_idxs)
                ev = events_affects(idx);
                y__ = ev{1}(0.0,y0);
            end
        else
            y__ = y0;
        end
    end

    function status = OutputFunc(time, y, flag)
        switch flag
            case 'done'
                assignin('base', 'output', integrator);
            case 'affect'
                integrator(end, :) = shared_values;
            otherwise
                integrator = [integrator; shared_values];
        end
        status = 0;
    end

    function dydt = ODEFunc(time, y)
        dydt = zeros(3, 1);
        Alc_g = y(1);
        vabs_Alc = p(1) * Alc_g;
        Alc_b = y(2) / p(9);
        v_ADH = p(2) * Alc_b / (p(3) + Alc_b) * p(9);
        AcHc = y(3) / p(9);
        v_ALDH = p(4) * AcHc / (p(5) + AcHc) * p(9);
        shared_values = [Alc_g, vabs_Alc, Alc_b, v_ADH, AcHc, v_ALDH];

        %%% Differential equations
        dydt(1) = -vabs_Alc;
        dydt(2) = vabs_Alc -v_ADH;
        dydt(3) = v_ADH -v_ALDH;
    end

    
    function res = sw1_condition(time, y)
        res = time - 2.0;
    end
    function res = sw2_condition(time, y)
        res = time - 4.0;
    end
    function y = sw1_affect(time, y)
        Alc_g = y(1);
        vabs_Alc = p(1) * Alc_g;
        Alc_b = y(2) / p(9);
        v_ADH = p(2) * Alc_b / (p(3) + Alc_b) * p(9);
        AcHc = y(3) / p(9);
        v_ALDH = p(4) * AcHc / (p(5) + AcHc) * p(9);

        if time ~= 0
            shared_values = [Alc_g, vabs_Alc, Alc_b, v_ADH, AcHc, v_ALDH];
            OutputFunc(time, y, 'affect');
        end

        %%% recalculated values
        y(1) = Alc_g + 50;
        
    end
    function y = sw2_affect(time, y)
        Alc_g = y(1);
        vabs_Alc = p(1) * Alc_g;
        Alc_b = y(2) / p(9);
        v_ADH = p(2) * Alc_b / (p(3) + Alc_b) * p(9);
        AcHc = y(3) / p(9);
        v_ALDH = p(4) * AcHc / (p(5) + AcHc) * p(9);

        if time ~= 0
            shared_values = [Alc_g, vabs_Alc, Alc_b, v_ADH, AcHc, v_ALDH];
            OutputFunc(time, y, 'affect');
        end

        %%% recalculated values
        y(1) = Alc_g + 50;
    end

    function [res,isterminal,direction] = Conditions(time, y)
        vec = p(6:7) ~= 0;
        len = sum(vec);

        direction = ones(len, 1);
        isterminal = ones(len, 1);
        res_full = [sw1_condition(time, y); sw2_condition(time, y)];
        % reduce to number of active events
        res = res_full(vec);
    end
end
