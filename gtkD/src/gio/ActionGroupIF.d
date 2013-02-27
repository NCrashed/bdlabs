/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version, with
 * some exceptions, please read the COPYING file.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110, USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = GActionGroup.html
 * outPack = gio
 * outFile = ActionGroupIF
 * strct   = GActionGroup
 * realStrct=
 * ctorStrct=
 * clss    = ActionGroupT
 * interf  = ActionGroupIF
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_action_group_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- glib.Str
 * 	- glib.Variant
 * 	- glib.VariantType
 * structWrap:
 * 	- GVariant* -> Variant
 * 	- GVariantType* -> VariantType
 * module aliases:
 * local aliases:
 * overrides:
 */

module gio.ActionGroupIF;

public  import gtkc.giotypes;

private import gtkc.gio;
private import glib.ConstructionException;
private import gobject.ObjectG;

private import gobject.Signals;
public  import gtkc.gdktypes;

private import glib.Str;
private import glib.Variant;
private import glib.VariantType;




/**
 * Description
 * GActionGroup represents a group of actions. Actions can be used to
 * expose functionality in a structured way, either from one part of a
 * program to another, or to the outside world. Action groups are often
 * used together with a GMenuModel that provides additional
 * representation data for displaying the actions to the user, e.g. in
 * a menu.
 * The main way to interact with the actions in a GActionGroup is to
 * activate them with g_action_group_activate_action(). Activating an
 * action may require a GVariant parameter. The required type of the
 * parameter can be inquired with g_action_group_get_action_parameter_type().
 * Actions may be disabled, see g_action_group_get_action_enabled().
 * Activating a disabled action has no effect.
 * Actions may optionally have a state in the form of a GVariant. The
 * current state of an action can be inquired with
 * g_action_group_get_action_state(). Activating a stateful action may
 * change its state, but it is also possible to set the state by calling
 * g_action_group_change_action_state().
 * As typical example, consider a text editing application which has an
 * option to change the current font to 'bold'. A good way to represent
 * this would be a stateful action, with a boolean state. Activating the
 * action would toggle the state.
 * Each action in the group has a unique name (which is a string). All
 * method calls, except g_action_group_list_actions() take the name of
 * an action as an argument.
 * The GActionGroup API is meant to be the 'public' API to the action
 * group. The calls here are exactly the interaction that 'external
 * forces' (eg: UI, incoming D-Bus messages, etc.) are supposed to have
 * with actions. 'Internal' APIs (ie: ones meant only to be accessed by
 * the action group implementation) are found on subclasses. This is
 * why you will find - for example - g_action_group_get_action_enabled()
 * but not an equivalent set() call.
 * Signals are emitted on the action group in response to state changes
 * on individual actions.
 * Implementations of GActionGroup should provide implementations for
 * the virtual functions g_action_group_list_actions() and
 * g_action_group_query_action(). The other virtual functions should
 * not be implemented - their "wrappers" are actually implemented with
 * calls to g_action_group_query_action().
 */
public interface ActionGroupIF
{
	
	
	public GActionGroup* getActionGroupTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	void delegate(string, ActionGroupIF)[] onActionAddedListeners();
	/**
	 * Signals that a new action was just added to the group.
	 * This signal is emitted after the action has been added
	 * and is now visible.
	 * Since 2.28
	 */
	void addOnActionAdded(void delegate(string, ActionGroupIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(string, gboolean, ActionGroupIF)[] onActionEnabledChangedListeners();
	/**
	 * Signals that the enabled status of the named action has changed.
	 * Since 2.28
	 */
	void addOnActionEnabledChanged(void delegate(string, gboolean, ActionGroupIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(string, ActionGroupIF)[] onActionRemovedListeners();
	/**
	 * Signals that an action is just about to be removed from the group.
	 * This signal is emitted before the action is removed, so the action
	 * is still visible and can be queried from the signal handler.
	 * Since 2.28
	 */
	void addOnActionRemoved(void delegate(string, ActionGroupIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(string, Variant, ActionGroupIF)[] onActionStateChangedListeners();
	/**
	 * Signals that the state of the named action has changed.
	 * Since 2.28
	 * See Also
	 * GAction
	 */
	void addOnActionStateChanged(void delegate(string, Variant, ActionGroupIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	
	/**
	 * Lists the actions contained within action_group.
	 * The caller is responsible for freeing the list with g_strfreev() when
	 * it is no longer required.
	 * Since 2.28
	 * Returns: a NULL-terminated array of the names of the actions in the groupb. [transfer full]
	 */
	public string[] listActions();
	
	/**
	 * Queries all aspects of the named action within an action_group.
	 * This function acquires the information available from
	 * g_action_group_has_action(), g_action_group_get_action_enabled(),
	 * g_action_group_get_action_parameter_type(),
	 * g_action_group_get_action_state_type(),
	 * g_action_group_get_action_state_hint() and
	 * g_action_group_get_action_state() with a single function call.
	 * This provides two main benefits.
	 * The first is the improvement in efficiency that comes with not having
	 * to perform repeated lookups of the action in order to discover
	 * different things about it. The second is that implementing
	 * GActionGroup can now be done by only overriding this one virtual
	 * function.
	 * The interface provides a default implementation of this function that
	 * calls the individual functions, as required, to fetch the
	 * information. The interface also provides default implementations of
	 * those functions that call this function. All implementations,
	 * therefore, must override either this function or all of the others.
	 * If the action exists, TRUE is returned and any of the requested
	 * fields (as indicated by having a non-NULL reference passed in) are
	 * filled. If the action doesn't exist, FALSE is returned and the
	 * fields may or may not have been modified.
	 * Since 2.32
	 * Params:
	 * actionName = the name of an action in the group
	 * enabled = if the action is presently enabled. [out]
	 * parameterType = the parameter type, or NULL if none needed. [out][allow-none]
	 * stateType = the state type, or NULL if stateless. [out][allow-none]
	 * stateHint = the state hint, or NULL if none. [out][allow-none]
	 * state = the current state, or NULL if stateless. [out][allow-none]
	 * Returns: TRUE if the action exists, else FALSE
	 */
	public int queryAction(string actionName, out int enabled, out VariantType parameterType, out VariantType stateType, out Variant stateHint, out Variant state);
	
	/**
	 * Checks if the named action exists within action_group.
	 * Since 2.28
	 * Params:
	 * actionName = the name of the action to check for
	 * Returns: whether the named action exists
	 */
	public int hasAction(string actionName);
	
	/**
	 * Checks if the named action within action_group is currently enabled.
	 * An action must be enabled in order to be activated or in order to
	 * have its state changed from outside callers.
	 * Since 2.28
	 * Params:
	 * actionName = the name of the action to query
	 * Returns: whether or not the action is currently enabled
	 */
	public int getActionEnabled(string actionName);
	
	/**
	 * Queries the type of the parameter that must be given when activating
	 * the named action within action_group.
	 * When activating the action using g_action_group_activate_action(),
	 * the GVariant given to that function must be of the type returned
	 * by this function.
	 * In the case that this function returns NULL, you must not give any
	 * GVariant, but NULL instead.
	 * The parameter type of a particular action will never change but it is
	 * possible for an action to be removed and for a new action to be added
	 * with the same name but a different parameter type.
	 * Since 2.28
	 * Params:
	 * actionName = the name of the action to query
	 * Returns: the parameter type
	 */
	public VariantType getActionParameterType(string actionName);
	
	/**
	 * Queries the type of the state of the named action within
	 * action_group.
	 * If the action is stateful then this function returns the
	 * GVariantType of the state. All calls to
	 * g_action_group_change_action_state() must give a GVariant of this
	 * type and g_action_group_get_action_state() will return a GVariant
	 * of the same type.
	 * If the action is not stateful then this function will return NULL.
	 * In that case, g_action_group_get_action_state() will return NULL
	 * and you must not call g_action_group_change_action_state().
	 * The state type of a particular action will never change but it is
	 * possible for an action to be removed and for a new action to be added
	 * with the same name but a different state type.
	 * Since 2.28
	 * Params:
	 * actionName = the name of the action to query
	 * Returns: the state type, if the action is stateful. [transfer full]
	 */
	public VariantType getActionStateType(string actionName);
	
	/**
	 * Requests a hint about the valid range of values for the state of the
	 * named action within action_group.
	 * If NULL is returned it either means that the action is not stateful
	 * or that there is no hint about the valid range of values for the
	 * state of the action.
	 * If a GVariant array is returned then each item in the array is a
	 * possible value for the state. If a GVariant pair (ie: two-tuple) is
	 * returned then the tuple specifies the inclusive lower and upper bound
	 * of valid values for the state.
	 * In any case, the information is merely a hint. It may be possible to
	 * have a state value outside of the hinted range and setting a value
	 * within the range may fail.
	 * The return value (if non-NULL) should be freed with
	 * g_variant_unref() when it is no longer required.
	 * Since 2.28
	 * Params:
	 * actionName = the name of the action to query
	 * Returns: the state range hint. [transfer full]
	 */
	public Variant getActionStateHint(string actionName);
	
	/**
	 * Queries the current state of the named action within action_group.
	 * If the action is not stateful then NULL will be returned. If the
	 * action is stateful then the type of the return value is the type
	 * given by g_action_group_get_action_state_type().
	 * The return value (if non-NULL) should be freed with
	 * g_variant_unref() when it is no longer required.
	 * Since 2.28
	 * Params:
	 * actionName = the name of the action to query
	 * Returns: the current state of the action. [allow-none]
	 */
	public Variant getActionState(string actionName);
	
	/**
	 * Request for the state of the named action within action_group to be
	 * changed to value.
	 * The action must be stateful and value must be of the correct type.
	 * See g_action_group_get_action_state_type().
	 * This call merely requests a change. The action may refuse to change
	 * its state or may change its state to something other than value.
	 * See g_action_group_get_action_state_hint().
	 * If the value GVariant is floating, it is consumed.
	 * Since 2.28
	 * Params:
	 * actionName = the name of the action to request the change on
	 * value = the new state
	 */
	public void changeActionState(string actionName, Variant value);
	
	/**
	 * Activate the named action within action_group.
	 * If the action is expecting a parameter, then the correct type of
	 * parameter must be given as parameter. If the action is expecting no
	 * parameters then parameter must be NULL. See
	 * g_action_group_get_action_parameter_type().
	 * Since 2.28
	 * Params:
	 * actionName = the name of the action to activate
	 * parameter = parameters to the activation. [allow-none]
	 */
	public void activateAction(string actionName, Variant parameter);
	
	/**
	 * Emits the "action-added" signal on action_group.
	 * This function should only be called by GActionGroup implementations.
	 * Since 2.28
	 * Params:
	 * actionName = the name of an action in the group
	 */
	public void actionAdded(string actionName);
	
	/**
	 * Emits the "action-removed" signal on action_group.
	 * This function should only be called by GActionGroup implementations.
	 * Since 2.28
	 * Params:
	 * actionName = the name of an action in the group
	 */
	public void actionRemoved(string actionName);
	
	/**
	 * Emits the "action-enabled-changed" signal on action_group.
	 * This function should only be called by GActionGroup implementations.
	 * Since 2.28
	 * Params:
	 * actionName = the name of an action in the group
	 * enabled = whether or not the action is now enabled
	 */
	public void actionEnabledChanged(string actionName, int enabled);
	
	/**
	 * Emits the "action-state-changed" signal on action_group.
	 * This function should only be called by GActionGroup implementations.
	 * Since 2.28
	 * Signal Details
	 * The "action-added" signal
	 * void user_function (GActionGroup *action_group,
	 *  gchar *action_name,
	 *  gpointer user_data) : Has Details
	 * Signals that a new action was just added to the group.
	 * This signal is emitted after the action has been added
	 * and is now visible.
	 * Since 2.28
	 * Params:
	 * actionName = the name of an action in the group
	 * state = the new state of the named action
	 * actionName = the name of the action in action_group
	 */
	public void actionStateChanged(string actionName, Variant state);
}
