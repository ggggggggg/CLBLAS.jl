import OpenCL
const cl = OpenCL

## @api.blas_func(clblasSgemm, (UInt32, UInt32, UInt32,
##                              Csize_t, Csize_t, Csize_t, cl.CL_float, cl.CL_mem, Csize_t, Csize_t,
##                              cl.CL_mem, Csize_t, Csize_t, cl.CL_float, cl.CL_mem, Csize_t, Csize_t,
##                              cl.CL_uint, Ptr{cl.CL_command_queue}, cl.CL_uint, Ptr{cl.CL_event},
##                              Ptr{cl.CL_event}))

## @api.blas_func2(clblasSgemm, (UInt32, UInt32, UInt32,
##                 Csize_t, Csize_t, Csize_t, cl.CL_float, cl.CL_mem, Csize_t, Csize_t,
##                 cl.CL_mem, Csize_t, Csize_t, cl.CL_float, cl.CL_mem, Csize_t, Csize_t))

## macro blas_gemm(func, arrType, mulType)
##     quote
##         function $(esc(func))( at::UInt32, bt::UInt32,
##                 alpha::$mulType, A::@compat(Union{$arrType, Future}),
##                 B::@compat(Union{$arrType, Future}), beta::$mulType, C::@compat(Union{$arrType, Future}))


##             futures = to_futures(A, B, C)
##             m = convert(Csize_t, futures[1].dims[1])
##             n = convert(Csize_t, futures[2].dims[2])
##             k = convert(Csize_t, futures[1].dims[2])

##             ctx   = futures[3].ctx
##             queue = futures[3].queue
##             req_num_events, events = getEvents(futures)
##             future_to_return = Future(ctx, queue, futures[3].mem, futures[3].dims)

##             lda = m
##             ldb = k
##             ldc = m

##             $(esc(func))(uint32(1), at, bt,
##                         m, n, k,
##                         alpha, pointer(futures[1].mem), 0, lda,
##                         pointer(futures[2].mem), 0, ldb, beta,
##                         pointer(futures[3].mem), 0, ldc,
##                         uint32(1), [pointer(queue)],
##                         req_num_events,
##                         events,
##                         future_to_return.event)

##             return future_to_return
##          end
##     end
## end

## @blas_gemm(clblasSgemm, Array{cl.CL_float}, cl.CL_float)

## @api.blas_func(clblasDgemm, (UInt32, UInt32, UInt32,
##               Csize_t, Csize_t, Csize_t, cl.CL_double, cl.CL_mem, Csize_t, Csize_t,
##               cl.CL_mem, Csize_t, Csize_t, cl.CL_double, cl.CL_mem, Csize_t, Csize_t,
##               cl.cl_uint, Ptr{cl.CL_command_queue}, cl.CL_uint, Ptr{cl.CL_event},
##               Ptr{cl.CL_event}))

## @api.blas_func2(clblasDgemm, (UInt32, UInt32, UInt32,
##               Csize_t, Csize_t, Csize_t, cl.CL_double, cl.CL_mem, Csize_t, Csize_t,
##               cl.CL_mem, Csize_t, Csize_t, cl.CL_double, cl.CL_mem, Csize_t, Csize_t))

## @api.blas_func(clblasCgemm, (UInt32, UInt32, UInt32,
##             Csize_t, Csize_t, Csize_t, FloatComplex, cl.CL_mem, Csize_t, Csize_t,
##             cl.CL_mem, Csize_t, Csize_t, FloatComplex, cl.CL_mem, Csize_t, Csize_t,
##             cl.cl_uint, Ptr{cl.CL_command_queue}, cl.CL_uint, Ptr{cl.CL_event},
##             Ptr{cl.CL_event}))

## @api.blas_func2(clblasCgemm, (UInt32, UInt32, UInt32,
##             Csize_t, Csize_t, Csize_t, FloatComplex, cl.CL_mem, Csize_t, Csize_t,
##             cl.CL_mem, Csize_t, Csize_t, FloatComplex, cl.CL_mem, Csize_t, Csize_t))

## @api.blas_func(clblasZgemm, (UInt32, UInt32, UInt32,
##               Csize_t, Csize_t, Csize_t, DoubleComplex, cl.CL_mem, Csize_t, Csize_t,
##               cl.CL_mem, Csize_t, Csize_t, DoubleComplex, cl.CL_mem, Csize_t, Csize_t,
##               cl.cl_uint, Ptr{cl.CL_command_queue}, cl.CL_uint, Ptr{cl.CL_event},
##               Ptr{cl.CL_event}))

## @api.blas_func2(clblasZgemm, (UInt32, UInt32, UInt32,
##               Csize_t, Csize_t, Csize_t, DoubleComplex, cl.CL_mem, Csize_t, Csize_t,
##               cl.CL_mem, Csize_t, Csize_t, DoubleComplex, cl.CL_mem, Csize_t, Csize_t))



# new API

for (func, typ) in [(:clblasSgemm, cl.CL_float),
                    (:clblasDgemm, cl.CL_double),
                    (:clblasCgemm, CL_float2),
                    (:clblasZgemm, CL_double2)]

    ## @eval @blasfun $func(order::UInt32,
    ##                      transA::UInt32, transB::UInt32,
    ##                      M::Csize_t, N::Csize_t, K::Csize_t,
    ##                      alpha::$typ,
    ##                      A::cl.CL_mem, offA::Csize_t, lda::Csize_t,
    ##                      B::cl.CL_mem, offB::Csize_t, ldb::Csize_t,
    ##                      beta::$typ,
    ##                      C::cl.CL_mem, offC::Csize_t, ldc::Csize_t,
    ##                      n_queues::cl.CL_uint,
    ##                      queues::Ptr{cl.CL_command_queue},
    ##                      n_events_in_wait_list::cl.CL_uint,
    ##                      event_wait_list::Ptr{cl.CL_event},
    ##                      events::Ptr{cl.CL_event})

    ## @eval @blasfun2 $func(order::UInt32,
    ##                       transA::UInt32, transB::UInt32,
    ##                       M::Csize_t, N::Csize_t, K::Csize_t,
    ##                       alpha::$typ,
    ##                       A::cl.CL_mem, offA::Csize_t, lda::Csize_t,
    ##                       B::cl.CL_mem, offB::Csize_t, ldb::Csize_t,
    ##                       beta::$typ,
    ##                       C::cl.CL_mem, offC::Csize_t, ldc::Csize_t)
    
    @eval @blasfun $func(order::clblasOrder,
                              transA::clblasTranspose, transB::clblasTranspose,
                              M::Csize_t, N::Csize_t, K::Csize_t,
                              alpha::$typ,
                              A::cl.CL_mem, offA::Csize_t, lda::Csize_t,
                              B::cl.CL_mem, offB::Csize_t, ldb::Csize_t,
                              beta::$typ,
                              C::cl.CL_mem, offC::Csize_t, ldc::Csize_t,
                              n_queues::cl.CL_uint,
                              queues::Ptr{cl.CL_command_queue},
                              n_events_in_wait_list::cl.CL_uint,
                              event_wait_list::Ptr{cl.CL_event},
                              events::Ptr{cl.CL_event})

    @eval @blasfun2 $func(order::clblasOrder,
                               transA::clblasTranspose, transB::clblasTranspose,
                               M::Csize_t, N::Csize_t, K::Csize_t,
                               alpha::$typ,
                               A::cl.CL_mem, offA::Csize_t, lda::Csize_t,
                               B::cl.CL_mem, offB::Csize_t, ldb::Csize_t,
                               beta::$typ,
                               C::cl.CL_mem, offC::Csize_t, ldc::Csize_t)
    
end

