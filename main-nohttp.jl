using Dates

macro spawnprint(ex)
    quote
        Threads.@spawn try
            $(esc(ex))
        catch e
            @error "Exception in task" exception=(e, catch_backtrace())
        end
    end
end

function mypmap(f, c...)
    fx = map(c...) do x
        @spawnprint f(x)
    end
    fetch.(fx)
end

function mypforeach(f, c...)
    fx = map(c...) do x
        @spawnprint f(x)
    end
    foreach(fetch, fx)
end


println("Pre-loop salute $(now())")
for it in 1:11
    mydata = zeros(UInt64, 1024, 16)

    # for n in 1:16
    #     mydata[:,n] .= rand(UInt64,1024)
    # end
    # println("Pre-thread salute $it $(minimum(mydata)) $(maximum(mydata)) $(now())")

    # Threads.@threads for n in 1:16
    mypforeach(1:16) do n
        # mydata[:,n+1] .= rand(UInt64,1024)
        # @inbounds mydata[:,n+1] .= rand(UInt64,1024)
        mydata[:,n] .= rand(UInt64,1024)
    end
    println("Hello $it $(minimum(mydata)) $(maximum(mydata)) $(now())")
end
