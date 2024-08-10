import mitt from "mitt";

type ApplicationEvents = {
    "notify:success": string;
    "notify:error": string;
    "notify:info": string;
};

const emitter = mitt<ApplicationEvents>();

export const useEvent = emitter.emit;
export const useListen = emitter.on;
